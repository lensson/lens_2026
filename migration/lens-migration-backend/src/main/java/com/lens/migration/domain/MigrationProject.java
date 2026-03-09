package com.lens.migration.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.lens.migration.domain.enums.AiProvider;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import lombok.*;

/**
 * 迁移项目主表（migration_project）
 *
 * 一个迁移项目代表一次完整的设备固件升级数据迁移任务，包含：
 * - 设备型号与版本信息
 * - 迁移场景类型
 * - 当前状态
 *
 * 数据库：auto_migration
 * 表名：migration_project
 */
@TableName("migration_project")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationProject extends BaseEntity {

    /** 项目名称（用户自定义，如 "LWLT-C 26.2 → 26.3"） */
    @TableField("name")
    private String name;

    /** 项目描述 */
    @TableField("description")
    private String description;

    /** 目标设备型号（如 "ls-mf"） */
    @TableField("device_model")
    private String deviceModel;

    /** 目标板卡型号（如 "lwlt-c"） */
    @TableField("board_type")
    private String boardType;

    /** 源版本（旧版本，如 "26.2"） */
    @TableField("source_version")
    private String sourceVersion;

    /** 目标版本（新版本，如 "26.3"） */
    @TableField("target_version")
    private String targetVersion;

    /** 迁移场景类型：INTENT_DRIVEN / SCHEMA_DRIVEN / HYBRID */
    @TableField("migration_type")
    private MigrationType migrationType;

    /** 当前项目状态 */
    @TableField("status")
    @Builder.Default
    private MigrationStatus status = MigrationStatus.CREATED;

    /** 使用的 AI 提供商 */
    @TableField("ai_provider")
    @Builder.Default
    private AiProvider aiProvider = AiProvider.NONE;

    /** AI 使用的模型名称（如 "gpt-4o-mini"、"qwen2.5-coder:14b"） */
    @TableField("ai_model")
    private String aiModel;

    /** AI 生成轮次（记录最终使用了几轮迭代完成生成） */
    @TableField("ai_rounds_used")
    private Integer aiRoundsUsed;

    /** 项目创建者（JWT sub 或用户名） */
    @TableField("created_by")
    private String createdBy;

    /** 错误信息（当 status = FAILED 时记录原因） */
    @TableField("error_message")
    private String errorMessage;
}
