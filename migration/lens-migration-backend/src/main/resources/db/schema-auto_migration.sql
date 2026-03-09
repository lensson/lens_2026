-- ============================================================
-- auto_migration 数据库初始化脚本
-- 数据库：auto_migration
-- 用途：YANG 迁移工具持久化存储
-- 版本：1.0.0 (Phase 5)
-- ============================================================

-- 创建数据库（如不存在）
CREATE DATABASE IF NOT EXISTS auto_migration
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE auto_migration;

-- 授权（如需手动执行）
-- GRANT ALL PRIVILEGES ON auto_migration.* TO 'lens'@'%';
-- FLUSH PRIVILEGES;

-- ============================================================
-- 表结构说明（由 Hibernate ddl-auto=update 自动管理）
-- 此脚本仅作为文档用途和手动初始化时使用
-- ============================================================

-- 1. migration_project：迁移项目主表
-- migration_project
--   id               BIGINT AUTO_INCREMENT PK
--   name             VARCHAR(200) NOT NULL        项目名称
--   description      VARCHAR(2000)                描述
--   device_model     VARCHAR(100) NOT NULL        设备型号（如 ls-mf）
--   board_type       VARCHAR(100)                 板卡型号（如 lwlt-c）
--   source_version   VARCHAR(50)  NOT NULL        旧版本（如 26.2）
--   target_version   VARCHAR(50)  NOT NULL        新版本（如 26.3）
--   migration_type   VARCHAR(30)  NOT NULL        INTENT_DRIVEN / SCHEMA_DRIVEN / HYBRID
--   status           VARCHAR(30)  NOT NULL        CREATED / SCHEMA_UPLOADED / ... / COMPLETED / FAILED
--   ai_provider      VARCHAR(30)                  OPENAI / GITHUB / QWEN / DEEPSEEK / OLLAMA / NONE
--   ai_model         VARCHAR(100)                 具体模型名（如 gpt-4o-mini）
--   ai_rounds_used   INT                          AI 迭代轮次
--   created_by       VARCHAR(100)                 创建人（JWT sub）
--   error_message    VARCHAR(2000)                失败原因
--   created_at       DATETIME     NOT NULL        创建时间（自动）
--   updated_at       DATETIME     NOT NULL        更新时间（自动）

-- 2. migration_schema：Yang Schema 上传记录
-- migration_schema
--   id               BIGINT AUTO_INCREMENT PK
--   project_id       BIGINT       FK → migration_project.id
--   file_name        VARCHAR(255) NOT NULL        文件名
--   module_name      VARCHAR(200)                 Yang 模块名
--   schema_version   VARCHAR(20)  NOT NULL        source / target
--   is_deviation     TINYINT(1)   NOT NULL        是否为 Deviation Yang
--   storage_path     VARCHAR(500) NOT NULL        文件路径
--   file_size        BIGINT                       字节数
--   checksum         VARCHAR(64)                  MD5
--   remark           VARCHAR(500)
--   created_at       DATETIME     NOT NULL
--   updated_at       DATETIME     NOT NULL

-- 3. migration_example：XML 样本对
-- migration_example
--   id               BIGINT AUTO_INCREMENT PK
--   project_id       BIGINT       FK → migration_project.id
--   sample_name      VARCHAR(200) NOT NULL        样本名称
--   operation_type   VARCHAR(50)                  Netconf 操作类型
--   input_file_name  VARCHAR(255) NOT NULL        输入 XML 文件名
--   input_storage_path VARCHAR(500) NOT NULL      输入 XML 路径
--   expected_file_name VARCHAR(255) NOT NULL      期望输出文件名
--   expected_storage_path VARCHAR(500) NOT NULL   期望输出路径
--   root_xpath       VARCHAR(200)                 XPath 根节点
--   namespace_map    VARCHAR(2000)                命名空间映射（JSON）
--   remark           VARCHAR(500)
--   created_at       DATETIME     NOT NULL
--   updated_at       DATETIME     NOT NULL

-- 4. migration_intent：意图文档
-- migration_intent
--   id               BIGINT AUTO_INCREMENT PK
--   project_id       BIGINT       FK → migration_project.id
--   version          INT          NOT NULL        版本号（递增）
--   file_name        VARCHAR(255) NOT NULL
--   storage_path     VARCHAR(500) NOT NULL
--   content          TEXT                         Markdown 内容
--   parsed_rules     TEXT                         解析后规则 JSON
--   rules_count      INT                          规则数量
--   is_active        TINYINT(1)   NOT NULL        是否激活
--   remark           VARCHAR(500)
--   created_at       DATETIME     NOT NULL
--   updated_at       DATETIME     NOT NULL

-- 5. migration_artifact：生成产物
-- migration_artifact
--   id               BIGINT AUTO_INCREMENT PK
--   project_id       BIGINT       FK → migration_project.id
--   intent_id        BIGINT       FK → migration_intent.id（可空）
--   artifact_type    VARCHAR(30)  NOT NULL        XSLT / YANG_SCHEMA / INPUT_XML / ...
--   file_name        VARCHAR(255) NOT NULL
--   storage_path     VARCHAR(500) NOT NULL
--   file_size        BIGINT
--   content          MEDIUMTEXT                   文件内容（直接存储）
--   ai_conversation_history TEXT                  AI 对话历史 JSON
--   generation_time_ms BIGINT                     生成耗时（ms）
--   tokens_used      INT                          Token 消耗
--   version          INT          NOT NULL        版本号
--   is_active        TINYINT(1)   NOT NULL        是否激活
--   created_at       DATETIME     NOT NULL
--   updated_at       DATETIME     NOT NULL

-- 6. migration_test_run：测试执行记录
-- migration_test_run
--   id               BIGINT AUTO_INCREMENT PK
--   project_id       BIGINT       FK → migration_project.id
--   artifact_id      BIGINT       FK → migration_artifact.id
--   status           VARCHAR(20)  NOT NULL        RUNNING / PASSED / FAILED / ERROR
--   total_cases      INT
--   passed_cases     INT
--   failed_cases     INT
--   error_cases      INT
--   duration_ms      BIGINT
--   raw_report       TEXT                         pytest 原始报告
--   error_summary    VARCHAR(2000)
--   created_at       DATETIME     NOT NULL
--   updated_at       DATETIME     NOT NULL

-- 7. migration_test_case_result：单条用例结果
-- migration_test_case_result
--   id               BIGINT AUTO_INCREMENT PK
--   test_run_id      BIGINT       FK → migration_test_run.id
--   example_id       BIGINT       FK → migration_example.id
--   case_name        VARCHAR(200) NOT NULL
--   status           VARCHAR(20)  NOT NULL
--   actual_output_path VARCHAR(500)
--   diff_detail      TEXT
--   error_message    VARCHAR(2000)
--   duration_ms      BIGINT
--   created_at       DATETIME     NOT NULL
--   updated_at       DATETIME     NOT NULL

