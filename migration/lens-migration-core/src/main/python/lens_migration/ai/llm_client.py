"""
LLM Client Module（大语言模型客户端模块）

提供统一的 LLM 调用接口，屏蔽不同模型 Provider 的 API 差异。

支持的 Provider：
  - OpenAI        (gpt-4o, gpt-4-turbo, gpt-3.5-turbo)
  - Anthropic     Claude (claude-3-5-sonnet, claude-3-haiku)
  - Ollama        (本地部署，任意模型，如 llama3、mistral、qwen2.5)
  - Qwen          (阿里云通义千问，qwen-plus、qwen-turbo、qwen-max 等)
  - Deepseek      (深度求索，deepseek-chat、deepseek-reasoner 等)
  - GitHubModels  (GitHub Models 免费推理，使用 GitHub Token，无需单独申请 Key)
  - Mock          (单元测试专用，无需真实 API Key)

使用方式（推荐通过工厂函数创建）：
    from lens_migration.ai.llm_client import create_llm_client

    # 使用 OpenAI
    client = create_llm_client("openai", model="gpt-4o")

    # 使用本地 Ollama
    client = create_llm_client("ollama", model="llama3.2")

    # 使用 GitHub Models（只需 GitHub Token，无需单独申请 Key）
    # export GITHUB_TOKEN=ghp_xxxx  （或 GitHub Actions 中的 secrets.GITHUB_TOKEN）
    client = create_llm_client("github", model="gpt-4o")

    # Mock（测试用）
    client = create_llm_client("mock", fixed_response="<xsl:template>...</xsl:template>")

    response = client.chat("请生成一段 XSLT ...")
    print(response.content)

配置优先级：
  1. 构造函数参数
  2. 环境变量（OPENAI_API_KEY / ANTHROPIC_API_KEY / OLLAMA_BASE_URL）
  3. .env 文件
"""

import os
import time
import logging
from abc import ABC, abstractmethod
from dataclasses import dataclass, field
from typing import Optional, List, Dict, Any

from tenacity import (
    retry,
    stop_after_attempt,
    wait_exponential,
    retry_if_exception_type,
    before_sleep_log,
)

logger = logging.getLogger(__name__)

# ── 尝试加载 .env 文件（可选，不影响无 dotenv 的环境）────────────────────────
try:
    from dotenv import load_dotenv
    load_dotenv()
except ImportError:
    pass


# ─────────────────────────────────────────────────────────────────────────────
# 数据类：消息和响应
# ─────────────────────────────────────────────────────────────────────────────

@dataclass
class ChatMessage:
    """单条对话消息。"""
    role: str       # "system" | "user" | "assistant"
    content: str


@dataclass
class LLMResponse:
    """
    LLM 调用响应。

    Attributes:
        content:      模型返回的文本内容
        model:        实际使用的模型名称
        provider:     Provider 名称（openai / anthropic / ollama / mock）
        input_tokens: 输入 token 数（不支持时为 0）
        output_tokens: 输出 token 数（不支持时为 0）
        latency_ms:   本次调用耗时（毫秒）
        raw:          原始响应对象（供调试用）
    """
    content: str
    model: str
    provider: str
    input_tokens: int = 0
    output_tokens: int = 0
    latency_ms: float = 0.0
    raw: Any = field(default=None, repr=False)

    @property
    def total_tokens(self) -> int:
        return self.input_tokens + self.output_tokens


# ─────────────────────────────────────────────────────────────────────────────
# 抽象基类
# ─────────────────────────────────────────────────────────────────────────────

class LLMClient(ABC):
    """
    LLM Provider 抽象基类。

    所有 Provider 实现必须继承此类，并实现 `_do_chat()` 方法。
    重试逻辑、日志、耗时统计由基类统一处理。
    """

    def __init__(self, model: str, max_retries: int = 3):
        self.model = model
        self.max_retries = max_retries
        logger.info(f"[{self.__class__.__name__}] 初始化，模型={model}，最大重试={max_retries}")

    @property
    @abstractmethod
    def provider_name(self) -> str:
        """Provider 标识字符串，用于日志和响应中。"""

    @abstractmethod
    def _do_chat(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        """
        执行实际的 LLM 调用（由子类实现）。

        Args:
            messages: 对话消息列表（含 system / user / assistant）
            **kwargs: 额外参数（temperature、max_tokens 等）

        Returns:
            LLMResponse 对象
        """

    def chat(
        self,
        prompt: str,
        system_prompt: Optional[str] = None,
        history: Optional[List[ChatMessage]] = None,
        temperature: float = 0.2,
        max_tokens: int = 4096,
    ) -> LLMResponse:
        """
        发送单轮或多轮对话请求。

        Args:
            prompt:        用户消息内容
            system_prompt: 系统提示词（可选）
            history:       历史消息列表（多轮对话时传入）
            temperature:   采样温度（0=确定性，1=创意性），默认 0.2（代码生成场景）
            max_tokens:    最大输出 token 数

        Returns:
            LLMResponse 对象
        """
        # 构造消息列表
        messages: List[ChatMessage] = []
        if system_prompt:
            messages.append(ChatMessage(role="system", content=system_prompt))
        if history:
            messages.extend(history)
        messages.append(ChatMessage(role="user", content=prompt))

        logger.info(f"[{self.provider_name}] 发送请求，模型={self.model}，"
                    f"消息数={len(messages)}，max_tokens={max_tokens}")
        logger.debug(f"[{self.provider_name}] 用户消息预览: {prompt[:200]}...")

        start = time.time()
        response = self._call_with_retry(messages, temperature=temperature, max_tokens=max_tokens)
        response.latency_ms = (time.time() - start) * 1000

        logger.info(f"[{self.provider_name}] 响应完成，"
                    f"tokens={response.input_tokens}+{response.output_tokens}，"
                    f"耗时={response.latency_ms:.0f}ms")
        logger.debug(f"[{self.provider_name}] 响应预览: {response.content[:300]}...")

        return response

    def _call_with_retry(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        """带指数退避重试的调用包装器。"""
        @retry(
            stop=stop_after_attempt(self.max_retries),
            wait=wait_exponential(multiplier=1, min=2, max=30),
            retry=retry_if_exception_type((ConnectionError, TimeoutError, OSError)),
            before_sleep=before_sleep_log(logger, logging.WARNING),
            reraise=True,
        )
        def _inner():
            return self._do_chat(messages, **kwargs)

        return _inner()


# ─────────────────────────────────────────────────────────────────────────────
# OpenAI Provider
# ─────────────────────────────────────────────────────────────────────────────

class OpenAIClient(LLMClient):
    """
    OpenAI API 客户端。

    需要环境变量：OPENAI_API_KEY
    可选环境变量：OPENAI_BASE_URL（兼容 Azure OpenAI 或第三方代理）

    支持的模型：gpt-4o、gpt-4-turbo、gpt-4、gpt-3.5-turbo
    """

    def __init__(
        self,
        model: str = "gpt-4o",
        api_key: Optional[str] = None,
        base_url: Optional[str] = None,
        max_retries: int = 3,
    ):
        super().__init__(model, max_retries)
        try:
            from openai import OpenAI
        except ImportError:
            raise ImportError("请安装 openai 包: pip install openai>=1.0.0")

        self._client = OpenAI(
            api_key=api_key or os.environ.get("OPENAI_API_KEY"),
            base_url=base_url or os.environ.get("OPENAI_BASE_URL"),
        )
        logger.info(f"[OpenAI] 客户端就绪，base_url={self._client.base_url}")

    @property
    def provider_name(self) -> str:
        return "openai"

    def _do_chat(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        openai_messages = [{"role": m.role, "content": m.content} for m in messages]
        resp = self._client.chat.completions.create(
            model=self.model,
            messages=openai_messages,
            temperature=kwargs.get("temperature", 0.2),
            max_tokens=kwargs.get("max_tokens", 4096),
        )
        choice = resp.choices[0]
        return LLMResponse(
            content=choice.message.content or "",
            model=resp.model,
            provider=self.provider_name,
            input_tokens=resp.usage.prompt_tokens if resp.usage else 0,
            output_tokens=resp.usage.completion_tokens if resp.usage else 0,
            raw=resp,
        )


# ─────────────────────────────────────────────────────────────────────────────
# Anthropic Provider
# ─────────────────────────────────────────────────────────────────────────────

class AnthropicClient(LLMClient):
    """
    Anthropic Claude API 客户端。

    需要环境变量：ANTHROPIC_API_KEY
    支持的模型：claude-3-5-sonnet-20241022、claude-3-haiku-20240307
    """

    def __init__(
        self,
        model: str = "claude-3-5-sonnet-20241022",
        api_key: Optional[str] = None,
        max_retries: int = 3,
    ):
        super().__init__(model, max_retries)
        try:
            import anthropic as _anthropic
        except ImportError:
            raise ImportError("请安装 anthropic 包: pip install anthropic>=0.18.0")

        self._anthropic = _anthropic
        self._client = _anthropic.Anthropic(
            api_key=api_key or os.environ.get("ANTHROPIC_API_KEY"),
        )
        logger.info("[Anthropic] 客户端就绪")

    @property
    def provider_name(self) -> str:
        return "anthropic"

    def _do_chat(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        # Anthropic 将 system 消息单独传入，不放在 messages 列表
        system_content = ""
        user_messages = []
        for m in messages:
            if m.role == "system":
                system_content = m.content
            else:
                user_messages.append({"role": m.role, "content": m.content})

        create_kwargs: Dict[str, Any] = dict(
            model=self.model,
            max_tokens=kwargs.get("max_tokens", 4096),
            temperature=kwargs.get("temperature", 0.2),
            messages=user_messages,
        )
        if system_content:
            create_kwargs["system"] = system_content

        resp = self._client.messages.create(**create_kwargs)
        content = "".join(
            block.text for block in resp.content
            if hasattr(block, "text")
        )
        return LLMResponse(
            content=content,
            model=resp.model,
            provider=self.provider_name,
            input_tokens=resp.usage.input_tokens if resp.usage else 0,
            output_tokens=resp.usage.output_tokens if resp.usage else 0,
            raw=resp,
        )


# ─────────────────────────────────────────────────────────────────────────────
# Ollama Provider（本地部署）
# ─────────────────────────────────────────────────────────────────────────────

class OllamaClient(LLMClient):
    """
    Ollama 本地（或远程）模型客户端。

    通过 OpenAI 兼容接口调用 Ollama 服务，认证方式与其他 Provider 保持一致：
      - 本地无认证：OLLAMA_API_KEY 未设置时，自动使用 "ollama" 占位符
      - 远程带认证：设置 OLLAMA_API_KEY 即可（部分托管 Ollama 服务需要）

    环境变量：
      OLLAMA_BASE_URL  — 服务地址，默认 http://localhost:11434/v1
      OLLAMA_API_KEY   — API Key（本地部署可不设置，远程带认证时必填）
      OLLAMA_MODEL     — 默认模型（可被构造参数覆盖）

    推荐模型：
      qwen3:8b          — Qwen 最新版（2025.04），~5GB，默认
      qwen3:4b          — Qwen3 精简版，~2.5GB
      qwen2.5-coder:7b  — 代码专用，~4.7GB
      qwen2.5-coder:3b  — 最小版，~2GB，CPU 可运行

    使用前需先启动 Ollama 服务并拉取模型：
        ollama serve
        ollama pull qwen3:8b
    """

    DEFAULT_BASE_URL = "http://localhost:11434/v1"

    def __init__(
        self,
        model: str = "qwen3:8b",
        api_key: Optional[str] = None,
        base_url: Optional[str] = None,
        max_retries: int = 2,
    ):
        super().__init__(model, max_retries)
        try:
            from openai import OpenAI
        except ImportError:
            raise ImportError("请安装 openai 包（Ollama 使用其兼容接口）: pip install openai>=1.0.0")

        self._base_url = base_url or os.environ.get("OLLAMA_BASE_URL", self.DEFAULT_BASE_URL)
        # 优先用显式参数，其次 OLLAMA_API_KEY 环境变量，最后 fallback 到 "ollama" 占位符
        # （本地 Ollama 不校验 API Key，任意非空字符串均可）
        resolved_key = api_key or os.environ.get("OLLAMA_API_KEY", "ollama")
        self._client = OpenAI(api_key=resolved_key, base_url=self._base_url)
        logger.info(f"[Ollama] 客户端就绪，base_url={self._base_url}，模型={model}，"
                    f"api_key={'(set)' if resolved_key != 'ollama' else '(local/no-auth)'}")

    @property
    def provider_name(self) -> str:
        return "ollama"

    def _do_chat(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        openai_messages = [{"role": m.role, "content": m.content} for m in messages]
        resp = self._client.chat.completions.create(
            model=self.model,
            messages=openai_messages,
            temperature=kwargs.get("temperature", 0.2),
            max_tokens=kwargs.get("max_tokens", 4096),
        )
        choice = resp.choices[0]
        return LLMResponse(
            content=choice.message.content or "",
            model=resp.model,
            provider=self.provider_name,
            input_tokens=resp.usage.prompt_tokens if resp.usage else 0,
            output_tokens=resp.usage.completion_tokens if resp.usage else 0,
            raw=resp,
        )


# ─────────────────────────────────────────────────────────────────────────────
# Qwen Provider（阿里云通义千问）
# ─────────────────────────────────────────────────────────────────────────────

class QwenClient(LLMClient):
    """
    阿里云通义千问（Qwen）API 客户端。

    使用 DashScope OpenAI 兼容端点，无需额外 SDK。
    API 文档：https://help.aliyun.com/zh/model-studio/developer-reference/

    需要环境变量：DASHSCOPE_API_KEY（即 Qwen API Key）
    可选环境变量：QWEN_BASE_URL（覆盖默认端点）

    支持的模型：
      - qwen-plus       （推荐，平衡性能与成本）
      - qwen-turbo      （最快，适合简单任务）
      - qwen-max        （最强，复杂推理）
      - qwen2.5-coder-32b-instruct（代码专用）

    示例：
        client = QwenClient(model="qwen-plus")
        # 或通过环境变量配置 API Key
        # export DASHSCOPE_API_KEY=sk-xxx
    """

    DEFAULT_BASE_URL = "https://dashscope.aliyuncs.com/compatible-mode/v1"

    def __init__(
        self,
        model: str = "qwen-plus",
        api_key: Optional[str] = None,
        base_url: Optional[str] = None,
        max_retries: int = 3,
    ):
        super().__init__(model, max_retries)
        try:
            from openai import OpenAI
        except ImportError:
            raise ImportError("请安装 openai 包: pip install openai>=1.0.0")

        resolved_key = api_key or os.environ.get("DASHSCOPE_API_KEY") or os.environ.get("QWEN_API_KEY")
        if not resolved_key:
            logger.warning("[Qwen] 未找到 API Key（DASHSCOPE_API_KEY），调用时将报错")

        self._base_url = base_url or os.environ.get("QWEN_BASE_URL", self.DEFAULT_BASE_URL)
        self._client = OpenAI(api_key=resolved_key or "missing", base_url=self._base_url)
        logger.info(f"[Qwen] 客户端就绪，base_url={self._base_url}，模型={model}")

    @property
    def provider_name(self) -> str:
        return "qwen"

    def _do_chat(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        openai_messages = [{"role": m.role, "content": m.content} for m in messages]
        resp = self._client.chat.completions.create(
            model=self.model,
            messages=openai_messages,
            temperature=kwargs.get("temperature", 0.2),
            max_tokens=kwargs.get("max_tokens", 4096),
        )
        choice = resp.choices[0]
        return LLMResponse(
            content=choice.message.content or "",
            model=resp.model,
            provider=self.provider_name,
            input_tokens=resp.usage.prompt_tokens if resp.usage else 0,
            output_tokens=resp.usage.completion_tokens if resp.usage else 0,
            raw=resp,
        )


# ─────────────────────────────────────────────────────────────────────────────
# Deepseek Provider
# ─────────────────────────────────────────────────────────────────────────────

class DeepseekClient(LLMClient):
    """
    Deepseek API 客户端。

    使用 Deepseek 官方 OpenAI 兼容端点。
    API 文档：https://platform.deepseek.com/api-docs/

    需要环境变量：DEEPSEEK_API_KEY
    可选环境变量：DEEPSEEK_BASE_URL（覆盖默认端点）

    支持的模型：
      - deepseek-chat     （DeepSeek-V3，通用对话与代码）
      - deepseek-reasoner （DeepSeek-R1，链式推理，复杂逻辑）

    示例：
        client = DeepseekClient(model="deepseek-chat")
        # export DEEPSEEK_API_KEY=sk-xxx
    """

    DEFAULT_BASE_URL = "https://api.deepseek.com/v1"

    def __init__(
        self,
        model: str = "deepseek-chat",
        api_key: Optional[str] = None,
        base_url: Optional[str] = None,
        max_retries: int = 3,
    ):
        super().__init__(model, max_retries)
        try:
            from openai import OpenAI
        except ImportError:
            raise ImportError("请安装 openai 包: pip install openai>=1.0.0")

        resolved_key = api_key or os.environ.get("DEEPSEEK_API_KEY")
        if not resolved_key:
            logger.warning("[Deepseek] 未找到 API Key（DEEPSEEK_API_KEY），调用时将报错")

        self._base_url = base_url or os.environ.get("DEEPSEEK_BASE_URL", self.DEFAULT_BASE_URL)
        self._client = OpenAI(api_key=resolved_key or "missing", base_url=self._base_url)
        logger.info(f"[Deepseek] 客户端就绪，base_url={self._base_url}，模型={model}")

    @property
    def provider_name(self) -> str:
        return "deepseek"

    def _do_chat(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        openai_messages = [{"role": m.role, "content": m.content} for m in messages]
        resp = self._client.chat.completions.create(
            model=self.model,
            messages=openai_messages,
            temperature=kwargs.get("temperature", 0.2),
            max_tokens=kwargs.get("max_tokens", 4096),
        )
        choice = resp.choices[0]
        return LLMResponse(
            content=choice.message.content or "",
            model=resp.model,
            provider=self.provider_name,
            input_tokens=resp.usage.prompt_tokens if resp.usage else 0,
            output_tokens=resp.usage.completion_tokens if resp.usage else 0,
            raw=resp,
        )


# ─────────────────────────────────────────────────────────────────────────────
# GitHub Models Provider
# ─────────────────────────────────────────────────────────────────────────────

class GitHubModelsClient(LLMClient):
    """
    GitHub Models 免费推理客户端。

    GitHub Models 是 GitHub 提供的模型推理服务，使用 GitHub Personal Access Token
    即可访问，无需单独申请 OpenAI / Azure 账号，非常适合在线快速测试。

    前提条件：
      1. 拥有 GitHub 账号
      2. 在 https://github.com/settings/tokens 生成一个 Personal Access Token（PAT）
         - 勾选 "Models" 权限（或使用 Classic Token，权限选 public_repo 即可）
      3. 将 Token 设置到环境变量：export GITHUB_TOKEN=ghp_xxxx

    端点地址：https://models.inference.ai.azure.com（GitHub 官方推理网关）
    API 文档：https://docs.github.com/en/github-models

    支持的模型（GitHub Models 目前可用，实时列表见官网）：
      - gpt-4o                      （OpenAI，推荐）
      - gpt-4o-mini                 （OpenAI，更快更便宜）
      - o1-mini                     （OpenAI，推理增强）
      - Meta-Llama-3.1-70B-Instruct （Meta，开源）
      - Mistral-large-2407          （Mistral AI）
      - Phi-3.5-MoE-instruct        （Microsoft）

    使用示例：
        # 方式1：环境变量（推荐）
        export GITHUB_TOKEN=ghp_xxxx
        client = GitHubModelsClient()

        # 方式2：直接传入 token
        client = GitHubModelsClient(token="ghp_xxxx", model="gpt-4o-mini")

        # 方式3：通过工厂函数
        client = create_llm_client("github", model="gpt-4o")

    注意事项：
      - GitHub Models 对个人账号有频率限制（Rate Limit），测试时请适当控制请求频率
      - 生产环境建议使用付费 API（OpenAI / Azure），GitHub Models 仅适合开发测试
    """

    DEFAULT_BASE_URL = "https://models.inference.ai.azure.com"

    def __init__(
        self,
        model: str = "gpt-4o",
        token: Optional[str] = None,
        base_url: Optional[str] = None,
        max_retries: int = 3,
    ):
        super().__init__(model, max_retries)
        try:
            from openai import OpenAI
        except ImportError:
            raise ImportError("请安装 openai 包: pip install openai>=1.0.0")

        # Token 读取优先级：构造参数 > GITHUB_TOKEN > GH_TOKEN
        resolved_token = token or os.environ.get("GITHUB_TOKEN") or os.environ.get("GH_TOKEN")
        if not resolved_token:
            raise ValueError(
                "[GitHubModels] 未找到 GitHub Token。\n"
                "请设置环境变量 GITHUB_TOKEN=ghp_xxxx\n"
                "Token 申请地址：https://github.com/settings/tokens"
            )

        self._base_url = base_url or os.environ.get("GITHUB_MODELS_BASE_URL", self.DEFAULT_BASE_URL)
        # GitHub Models 使用 Bearer Token 作为 API Key
        self._client = OpenAI(api_key=resolved_token, base_url=self._base_url)
        logger.info(f"[GitHubModels] 客户端就绪，base_url={self._base_url}，模型={model}")

    @property
    def provider_name(self) -> str:
        return "github"

    def _do_chat(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        openai_messages = [{"role": m.role, "content": m.content} for m in messages]
        resp = self._client.chat.completions.create(
            model=self.model,
            messages=openai_messages,
            temperature=kwargs.get("temperature", 0.2),
            max_tokens=kwargs.get("max_tokens", 4096),
        )
        choice = resp.choices[0]
        return LLMResponse(
            content=choice.message.content or "",
            model=resp.model,
            provider=self.provider_name,
            input_tokens=resp.usage.prompt_tokens if resp.usage else 0,
            output_tokens=resp.usage.completion_tokens if resp.usage else 0,
            raw=resp,
        )


# ─────────────────────────────────────────────────────────────────────────────
# Mock Provider（单元测试专用）
# ─────────────────────────────────────────────────────────────────────────────

class MockLLMClient(LLMClient):
    """
    Mock LLM 客户端，用于单元测试，无需真实 API Key 和网络。

    支持两种模式：
      1. fixed_response：每次返回固定字符串
      2. response_map  ：根据 prompt 关键字返回不同字符串（精确匹配优先，否则 fallback）

    示例：
        # 固定响应
        client = MockLLMClient(fixed_response="<xsl:template>...</xsl:template>")

        # 关键字映射
        client = MockLLMClient(response_map={
            "rename": "<xsl:template match='...'>rename</xsl:template>",
            "delete": "<xsl:template match='...'>delete</xsl:template>",
        }, fallback="<xsl:template>fallback</xsl:template>")
    """

    def __init__(
        self,
        fixed_response: Optional[str] = None,
        response_map: Optional[Dict[str, str]] = None,
        fallback: str = "<xsl:template>mock-fallback</xsl:template>",
        simulate_latency_ms: float = 0.0,
    ):
        super().__init__(model="mock", max_retries=1)
        self._fixed = fixed_response
        self._map = response_map or {}
        self._fallback = fallback
        self._latency_ms = simulate_latency_ms
        # 记录所有调用，便于测试断言
        self.call_history: List[Dict[str, Any]] = []

    @property
    def provider_name(self) -> str:
        return "mock"

    def _do_chat(self, messages: List[ChatMessage], **kwargs) -> LLMResponse:
        if self._latency_ms > 0:
            time.sleep(self._latency_ms / 1000)

        last_user = next(
            (m.content for m in reversed(messages) if m.role == "user"), ""
        )

        # 记录调用
        self.call_history.append({
            "messages": [{"role": m.role, "content": m.content} for m in messages],
            "kwargs": kwargs,
        })

        # 决定返回内容
        if self._fixed is not None:
            content = self._fixed
        else:
            content = self._fallback
            for keyword, resp in self._map.items():
                if keyword.lower() in last_user.lower():
                    content = resp
                    break

        logger.debug(f"[Mock] 返回响应，长度={len(content)}")
        return LLMResponse(
            content=content,
            model="mock",
            provider="mock",
            input_tokens=len(last_user) // 4,
            output_tokens=len(content) // 4,
        )

    def reset(self):
        """清空调用历史，便于多个测试用例复用同一个 Mock 实例。"""
        self.call_history.clear()


# ─────────────────────────────────────────────────────────────────────────────
# 工厂函数
# ─────────────────────────────────────────────────────────────────────────────

def create_llm_client(
    provider: str = "openai",
    model: Optional[str] = None,
    **kwargs,
) -> LLMClient:
    """
    工厂函数：根据 provider 名称创建对应的 LLM 客户端。

    Args:
        provider: Provider 名称，可选：
                  "openai"、"anthropic"、"ollama"、"qwen"、"deepseek"、"github"、"mock"
                  也可通过环境变量 LLM_PROVIDER 指定默认 provider。
        model:    模型名称（不传则使用各 Provider 默认值）
        **kwargs: 传递给对应客户端构造函数的额外参数

    Returns:
        LLMClient 实例

    Raises:
        ValueError: provider 不在支持列表中
    """
    # 支持从环境变量读取默认 provider
    provider = provider or os.environ.get("LLM_PROVIDER", "openai")
    provider = provider.lower().strip()

    logger.info(f"[LLMFactory] 创建 LLM 客户端，provider={provider}，model={model or '(default)'}")

    if provider == "openai":
        return OpenAIClient(model=model or "gpt-4o", **kwargs)
    elif provider == "anthropic":
        return AnthropicClient(model=model or "claude-3-5-sonnet-20241022", **kwargs)
    elif provider in ("ollama", "local"):
        return OllamaClient(model=model or os.environ.get("OLLAMA_MODEL", "qwen3:8b"), **kwargs)
    elif provider in ("qwen", "dashscope", "tongyi"):
        return QwenClient(model=model or "qwen-plus", **kwargs)
    elif provider == "deepseek":
        return DeepseekClient(model=model or "deepseek-chat", **kwargs)
    elif provider in ("github", "github_models", "githubmodels"):
        return GitHubModelsClient(model=model or "gpt-4o", **kwargs)
    elif provider == "mock":
        return MockLLMClient(**kwargs)
    else:
        raise ValueError(
            f"不支持的 LLM provider: '{provider}'。"
            f"可选值: openai, anthropic, ollama, qwen, deepseek, github, mock"
        )

