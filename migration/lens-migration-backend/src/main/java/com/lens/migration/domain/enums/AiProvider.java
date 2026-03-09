package com.lens.migration.domain.enums;

/**
 * AI 提供商枚举
 *
 * 对应 lens-migration-core 中支持的 LLM Provider
 */
public enum AiProvider {

    /** OpenAI GPT 系列 */
    OPENAI,

    /** GitHub Models（基于 Azure OpenAI） */
    GITHUB,

    /** 阿里云通义千问 */
    QWEN,

    /** 深度求索 DeepSeek */
    DEEPSEEK,

    /** 本地 Ollama（默认 qwen3:8b） */
    OLLAMA,

    /** 不使用 AI，纯规则引擎生成 */
    NONE
}

