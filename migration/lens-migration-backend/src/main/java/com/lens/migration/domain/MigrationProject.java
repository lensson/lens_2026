package com.lens.migration.domain;

import com.lens.migration.domain.enums.AiProvider;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

/**
 * 迁移项目主表（migration_project）
 *
 * 一个迁移项目代表一次完整的设备固件升级数据迁移任务，包含：
 * - 设备型号与版本信息
 * - 迁移场景类型
 * - 当前状态
 * - 与所有关联实体（Schema、样本对、意图文档、产物、测试结果）的一对多关系
 *
 * 数据库：auto_migration
 * 表名：migration_project
 */
@Entity
@Table(name = "migration_project", indexes = {
    @Index(name = "idx_project_status", columnList = "status"),
    @Index(name = "idx_project_device_model", columnList = "device_model"),
    @Index(name = "idx_project_created_by", columnList = "created_by")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationProject extends BaseEntity {

    /**
     * 项目名称（用户自定义，如 "LWLT-C 26.2 → 26.3"）
     */
    @Column(name = "name", nullable = false, length = 200)
    private String name;

    /**
     * 项目描述
     */
    @Column(name = "description", length = 2000)
    private String description;

    /**
     * 目标设备型号（如 "ls-mf"）
     */
    @Column(name = "device_model", nullable = false, length = 100)
    private String deviceModel;

    /**
     * 目标板卡型号（如 "lwlt-c"）
     */
    @Column(name = "board_type", length = 100)
    private String boardType;

    /**
     * 源版本（旧版本，如 "26.2"）
     */
    @Column(name = "source_version", nullable = false, length = 50)
    private String sourceVersion;

    /**
     * 目标版本（新版本，如 "26.3"）
     */
    @Column(name = "target_version", nullable = false, length = 50)
    private String targetVersion;

    /**
     * 迁移场景类型：INTENT_DRIVEN / SCHEMA_DRIVEN / HYBRID
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "migration_type", nullable = false, length = 30)
    private MigrationType migrationType;

    /**
     * 当前项目状态
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 30)
    @Builder.Default
    private MigrationStatus status = MigrationStatus.CREATED;

    /**
     * 使用的 AI 提供商
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "ai_provider", length = 30)
    @Builder.Default
    private AiProvider aiProvider = AiProvider.NONE;

    /**
     * AI 使用的模型名称（如 "gpt-4o-mini"、"qwen2.5-coder:14b"）
     */
    @Column(name = "ai_model", length = 100)
    private String aiModel;

    /**
     * AI 生成轮次（记录最终使用了几轮迭代完成生成）
     */
    @Column(name = "ai_rounds_used")
    private Integer aiRoundsUsed;

    /**
     * 项目创建者（JWT sub 或用户名）
     */
    @Column(name = "created_by", length = 100)
    private String createdBy;

    /**
     * 错误信息（当 status = FAILED 时记录原因）
     */
    @Column(name = "error_message", length = 2000)
    private String errorMessage;

    /**
     * 关联的 Yang Schema 上传记录（一对多）
     */
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<MigrationSchema> schemas = new ArrayList<>();

    /**
     * 关联的 XML 样本对（一对多）
     */
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<MigrationExample> examples = new ArrayList<>();

    /**
     * 关联的意图文档（一对多，通常只有一个，但支持多版本）
     */
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<MigrationIntent> intents = new ArrayList<>();

    /**
     * 关联的生成产物（XSLT 等，一对多）
     */
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<MigrationArtifact> artifacts = new ArrayList<>();

    /**
     * 关联的测试执行记录（一对多）
     */
    @OneToMany(mappedBy = "project", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<MigrationTestRun> testRuns = new ArrayList<>();
}

