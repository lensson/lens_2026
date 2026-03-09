-- ============================================================
-- auto_migration 数据库 DDL
-- 数据库：auto_migration（MariaDB / MySQL，utf8mb4）
-- 版本：1.0.0  Phase 5 - MyBatis-Plus
-- 执行前请确保：CREATE DATABASE auto_migration CHARACTER SET utf8mb4;
-- ============================================================

USE auto_migration;

-- ============================================================
-- 1. migration_project  迁移项目主表
-- ============================================================
CREATE TABLE IF NOT EXISTS migration_project (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    name            VARCHAR(200)    NOT NULL COMMENT '项目名称，如 "LWLT-C 26.2→26.3"',
    description     VARCHAR(2000)            COMMENT '项目描述',
    device_model    VARCHAR(100)    NOT NULL COMMENT '设备型号，如 ls-mf',
    board_type      VARCHAR(100)             COMMENT '板卡型号，如 lwlt-c',
    source_version  VARCHAR(50)     NOT NULL COMMENT '源版本（旧），如 26.2',
    target_version  VARCHAR(50)     NOT NULL COMMENT '目标版本（新），如 26.3',
    migration_type  VARCHAR(30)     NOT NULL COMMENT '迁移类型：INTENT_DRIVEN/SCHEMA_DRIVEN/HYBRID',
    status          VARCHAR(30)     NOT NULL DEFAULT 'CREATED' COMMENT '项目状态',
    ai_provider     VARCHAR(30)              DEFAULT 'NONE' COMMENT 'AI 提供商',
    ai_model        VARCHAR(100)             COMMENT 'AI 模型名称',
    ai_rounds_used  INT                      COMMENT 'AI 迭代轮次',
    created_by      VARCHAR(100)             COMMENT '创建人（JWT sub）',
    error_message   VARCHAR(2000)            COMMENT '失败原因',
    created_at      DATETIME        NOT NULL COMMENT '创建时间（自动填充）',
    updated_at      DATETIME        NOT NULL COMMENT '更新时间（自动填充）',
    PRIMARY KEY (id),
    INDEX idx_project_status      (status),
    INDEX idx_project_device_model(device_model),
    INDEX idx_project_created_by  (created_by)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='迁移项目主表';


-- ============================================================
-- 2. migration_schema  Yang Schema 上传记录
-- ============================================================
CREATE TABLE IF NOT EXISTS migration_schema (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    project_id      BIGINT          NOT NULL COMMENT '所属迁移项目 ID',
    file_name       VARCHAR(255)    NOT NULL COMMENT 'Yang 文件名',
    module_name     VARCHAR(200)             COMMENT 'Yang 模块名称',
    schema_version  VARCHAR(20)     NOT NULL COMMENT 'source（旧）/ target（新）',
    is_deviation    TINYINT(1)      NOT NULL DEFAULT 0 COMMENT '是否为 Deviation Yang',
    storage_path    VARCHAR(500)    NOT NULL COMMENT '文件存储路径',
    file_size       BIGINT                   COMMENT '文件大小（字节）',
    checksum        VARCHAR(64)              COMMENT 'MD5 校验值',
    remark          VARCHAR(500)             COMMENT '备注',
    created_at      DATETIME        NOT NULL COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL COMMENT '更新时间',
    PRIMARY KEY (id),
    INDEX idx_schema_project_id  (project_id),
    INDEX idx_schema_version     (schema_version),
    CONSTRAINT fk_schema_project FOREIGN KEY (project_id) REFERENCES migration_project(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Yang Schema 上传记录';


-- ============================================================
-- 3. migration_example  XML 样本对
-- ============================================================
CREATE TABLE IF NOT EXISTS migration_example (
    id                      BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    project_id              BIGINT          NOT NULL COMMENT '所属迁移项目 ID',
    sample_name             VARCHAR(200)    NOT NULL COMMENT '样本名称，如 sample-01',
    operation_type          VARCHAR(50)              COMMENT 'Netconf 操作类型',
    input_file_name         VARCHAR(255)    NOT NULL COMMENT '输入 XML 文件名（旧版本）',
    input_storage_path      VARCHAR(500)    NOT NULL COMMENT '输入 XML 存储路径',
    expected_file_name      VARCHAR(255)    NOT NULL COMMENT '期望输出 XML 文件名（新版本）',
    expected_storage_path   VARCHAR(500)    NOT NULL COMMENT '期望输出 XML 存储路径',
    root_xpath              VARCHAR(200)             COMMENT 'XPath 根节点',
    namespace_map           VARCHAR(2000)            COMMENT '命名空间映射（JSON）',
    remark                  VARCHAR(500)             COMMENT '备注',
    created_at              DATETIME        NOT NULL COMMENT '创建时间',
    updated_at              DATETIME        NOT NULL COMMENT '更新时间',
    PRIMARY KEY (id),
    INDEX idx_example_project_id (project_id),
    INDEX idx_example_operation  (operation_type),
    CONSTRAINT fk_example_project FOREIGN KEY (project_id) REFERENCES migration_project(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='XML 样本对（输入旧版本 + 期望输出新版本）';


-- ============================================================
-- 4. migration_intent  意图文档
-- ============================================================
CREATE TABLE IF NOT EXISTS migration_intent (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    project_id      BIGINT          NOT NULL COMMENT '所属迁移项目 ID',
    version         INT             NOT NULL DEFAULT 1 COMMENT '版本号（每次上传递增）',
    file_name       VARCHAR(255)    NOT NULL COMMENT '意图文档文件名',
    storage_path    VARCHAR(500)    NOT NULL COMMENT '存储路径',
    content         TEXT                     COMMENT '意图文档 Markdown 内容',
    parsed_rules    TEXT                     COMMENT '解析后规则 JSON 数组',
    rules_count     INT                      COMMENT '规则数量',
    is_active       TINYINT(1)      NOT NULL DEFAULT 1 COMMENT '是否为激活版本',
    remark          VARCHAR(500)             COMMENT '备注',
    created_at      DATETIME        NOT NULL COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL COMMENT '更新时间',
    PRIMARY KEY (id),
    INDEX idx_intent_project_id (project_id),
    INDEX idx_intent_version    (project_id, version),
    CONSTRAINT fk_intent_project FOREIGN KEY (project_id) REFERENCES migration_project(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='迁移意图文档';


-- ============================================================
-- 5. migration_artifact  生成产物
-- ============================================================
CREATE TABLE IF NOT EXISTS migration_artifact (
    id                          BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    project_id                  BIGINT          NOT NULL COMMENT '所属迁移项目 ID',
    intent_id                   BIGINT                   COMMENT '关联意图文档 ID（可空）',
    artifact_type               VARCHAR(30)     NOT NULL COMMENT '产物类型（XSLT/INPUT_XML/...）',
    file_name                   VARCHAR(255)    NOT NULL COMMENT '产物文件名',
    storage_path                VARCHAR(500)    NOT NULL COMMENT '存储路径',
    file_size                   BIGINT                   COMMENT '文件大小（字节）',
    content                     MEDIUMTEXT               COMMENT '产物内容（直接存储便于预览）',
    ai_conversation_history     TEXT                     COMMENT 'AI 对话历史（JSON）',
    generation_time_ms          BIGINT                   COMMENT '生成耗时（ms）',
    tokens_used                 INT                      COMMENT 'AI Token 消耗',
    version                     INT             NOT NULL DEFAULT 1 COMMENT '版本号',
    is_active                   TINYINT(1)      NOT NULL DEFAULT 1 COMMENT '是否激活版本',
    created_at                  DATETIME        NOT NULL COMMENT '创建时间',
    updated_at                  DATETIME        NOT NULL COMMENT '更新时间',
    PRIMARY KEY (id),
    INDEX idx_artifact_project_id (project_id),
    INDEX idx_artifact_type       (artifact_type),
    INDEX idx_artifact_intent_id  (intent_id),
    CONSTRAINT fk_artifact_project FOREIGN KEY (project_id) REFERENCES migration_project(id) ON DELETE CASCADE,
    CONSTRAINT fk_artifact_intent  FOREIGN KEY (intent_id)  REFERENCES migration_intent(id)  ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='迁移产物（XSLT 等）';


-- ============================================================
-- 6. migration_test_run  测试执行记录
-- ============================================================
CREATE TABLE IF NOT EXISTS migration_test_run (
    id              BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    project_id      BIGINT          NOT NULL COMMENT '所属迁移项目 ID',
    artifact_id     BIGINT          NOT NULL COMMENT '被测 XSLT 产物 ID',
    status          VARCHAR(20)     NOT NULL DEFAULT 'RUNNING' COMMENT '执行状态',
    total_cases     INT             NOT NULL DEFAULT 0 COMMENT '总用例数',
    passed_cases    INT             NOT NULL DEFAULT 0 COMMENT '通过用例数',
    failed_cases    INT             NOT NULL DEFAULT 0 COMMENT '失败用例数',
    error_cases     INT             NOT NULL DEFAULT 0 COMMENT '出错用例数',
    duration_ms     BIGINT                   COMMENT '执行耗时（ms）',
    raw_report      TEXT                     COMMENT 'pytest 原始报告',
    error_summary   VARCHAR(2000)            COMMENT '错误摘要',
    created_at      DATETIME        NOT NULL COMMENT '创建时间',
    updated_at      DATETIME        NOT NULL COMMENT '更新时间',
    PRIMARY KEY (id),
    INDEX idx_test_run_project_id  (project_id),
    INDEX idx_test_run_artifact_id (artifact_id),
    INDEX idx_test_run_status      (status),
    CONSTRAINT fk_testrun_project  FOREIGN KEY (project_id)  REFERENCES migration_project(id)  ON DELETE CASCADE,
    CONSTRAINT fk_testrun_artifact FOREIGN KEY (artifact_id) REFERENCES migration_artifact(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='测试执行记录';


-- ============================================================
-- 7. migration_test_case_result  单条用例结果
-- ============================================================
CREATE TABLE IF NOT EXISTS migration_test_case_result (
    id                  BIGINT          NOT NULL AUTO_INCREMENT COMMENT '主键',
    test_run_id         BIGINT          NOT NULL COMMENT '所属测试执行批次 ID',
    example_id          BIGINT          NOT NULL COMMENT '对应 XML 样本对 ID',
    case_name           VARCHAR(200)    NOT NULL COMMENT '用例名称',
    status              VARCHAR(20)     NOT NULL COMMENT '执行结果（PASSED/FAILED/ERROR/SKIPPED）',
    actual_output_path  VARCHAR(500)             COMMENT '实际输出 XML 存储路径',
    diff_detail         TEXT                     COMMENT 'expected vs actual diff',
    error_message       VARCHAR(2000)            COMMENT '错误信息',
    duration_ms         BIGINT                   COMMENT '用例耗时（ms）',
    created_at          DATETIME        NOT NULL COMMENT '创建时间',
    updated_at          DATETIME        NOT NULL COMMENT '更新时间',
    PRIMARY KEY (id),
    INDEX idx_case_result_run_id     (test_run_id),
    INDEX idx_case_result_example_id (example_id),
    INDEX idx_case_result_status     (status),
    CONSTRAINT fk_caseresult_run     FOREIGN KEY (test_run_id) REFERENCES migration_test_run(id)    ON DELETE CASCADE,
    CONSTRAINT fk_caseresult_example FOREIGN KEY (example_id)  REFERENCES migration_example(id)    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='单条测试用例结果';
