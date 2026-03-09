package com.lens.migration.domain.enums;

/**
 * 产物类型枚举
 *
 * 描述 MigrationArtifact 中存储的文件类型
 */
public enum ArtifactType {

    /** 生成的 XSLT 转换文件 */
    XSLT,

    /** 上传的 Yang Schema 文件（.yang） */
    YANG_SCHEMA,

    /** 输入 XML 样本（旧版本） */
    INPUT_XML,

    /** 期望输出 XML 样本（新版本） */
    EXPECTED_XML,

    /** 实际转换输出 XML（测试产物） */
    ACTUAL_XML,

    /** 意图文档（Markdown） */
    INTENT_DOC,

    /** 测试报告（JSON/HTML） */
    TEST_REPORT
}

