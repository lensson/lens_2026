package com.lens.migration.domain.enums;

/**
 * 迁移项目状态枚举
 *
 * 描述一个迁移项目的完整生命周期：
 * CREATED → SCHEMA_UPLOADED → INTENT_UPLOADED → GENERATING → GENERATED → TESTING → COMPLETED / FAILED
 */
public enum MigrationStatus {

    /** 项目已创建，等待上传材料 */
    CREATED,

    /** Yang Schema 已上传 */
    SCHEMA_UPLOADED,

    /** 意图文档（Markdown）已上传 */
    INTENT_UPLOADED,

    /** XSLT 生成中（AI 调用进行中） */
    GENERATING,

    /** XSLT 已生成，等待测试 */
    GENERATED,

    /** 自动化测试运行中 */
    TESTING,

    /** 所有步骤完成，XSLT 可下载 */
    COMPLETED,

    /** 处理过程中发生错误 */
    FAILED
}

