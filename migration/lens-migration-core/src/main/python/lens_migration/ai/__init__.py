"""
lens_migration.ai —— AI 辅助子包（Phase 2）

提供以下能力：
  - LLMClient        : 统一 LLM 调用接口（OpenAI / Anthropic / Ollama / Qwen / Deepseek / GitHub / Mock）
  - PromptBuilder    : 将迁移意图 + XML 示例组装为 LLM Prompt
  - XSLTRefiner      : LLM 生成 XSLT + 验证失败时自动多轮迭代修正

快速使用：
    from lens_migration.ai import create_llm_client, XSLTRefiner

    # 使用 GitHub Models（只需 GITHUB_TOKEN，无需单独申请 API Key）
    client  = create_llm_client("github", model="gpt-4o")
    refiner = XSLTRefiner(client, max_rounds=3)
    result  = refiner.refine(intent, input_xml_str, input_xml_path)
"""

from lens_migration.ai.llm_client import (
    LLMClient,
    OpenAIClient,
    AnthropicClient,
    OllamaClient,
    QwenClient,
    DeepseekClient,
    GitHubModelsClient,
    MockLLMClient,
    LLMResponse,
    ChatMessage,
    create_llm_client,
)
from lens_migration.ai.prompt_builder import PromptBuilder
from lens_migration.ai.xslt_refiner import XSLTRefiner

__all__ = [
    "LLMClient",
    "OpenAIClient",
    "AnthropicClient",
    "OllamaClient",
    "QwenClient",
    "DeepseekClient",
    "GitHubModelsClient",
    "MockLLMClient",
    "LLMResponse",
    "ChatMessage",
    "create_llm_client",
    "PromptBuilder",
    "XSLTRefiner",
]
