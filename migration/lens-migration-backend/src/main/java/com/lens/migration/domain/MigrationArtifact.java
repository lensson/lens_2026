package com.lens.migration.domain;

import com.lens.migration.domain.enums.ArtifactType;
import jakarta.persistence.*;
import lombok.*;

/**
 * 迁移产物记录（migration_artifact）
 *
 * 存储迁移过程中生成或产生的所有文件：
 * - 生成的 XSLT 转换文件（核心产物）
 * - 转换后的实际 XML 输出（测试产物）
 * - AI 对话历史（JSON，便于调试回溯）
 *
 * 数据库：auto_migration
 * 表名：migration_artifact
 */
@Entity
@Table(name = "migration_artifact", indexes = {
    @Index(name = "idx_artifact_project_id", columnList = "project_id"),
    @Index(name = "idx_artifact_type", columnList = "artifact_type"),
    @Index(name = "idx_artifact_intent_id", columnList = "intent_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationArtifact extends BaseEntity {

    /**
     * 所属迁移项目
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "project_id", nullable = false)
    private MigrationProject project;

    /**
     * 关联的意图文档（生成此产物时使用的意图版本，可为空）
     */
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "intent_id")
    private MigrationIntent intent;

    /**
     * 产物类型
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "artifact_type", nullable = false, length = 30)
    private ArtifactType artifactType;

    /**
     * 产物文件名
     */
    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;

    /**
     * 产物存储路径（相对于 storage.base-path）
     */
    @Column(name = "storage_path", nullable = false, length = 500)
    private String storagePath;

    /**
     * 文件大小（字节）
     */
    @Column(name = "file_size")
    private Long fileSize;

    /**
     * 产物内容（对于 XSLT 和小型 XML，直接存入数据库便于快速预览）
     * 使用 MEDIUMTEXT，支持最大 16MB 内容
     */
    @Column(name = "content", columnDefinition = "MEDIUMTEXT")
    private String content;

    /**
     * AI 生成时的对话历史（JSON 格式，记录每轮 prompt + response）
     * 仅对 XSLT 类型产物有效
     */
    @Column(name = "ai_conversation_history", columnDefinition = "TEXT")
    private String aiConversationHistory;

    /**
     * 生成耗时（毫秒）
     */
    @Column(name = "generation_time_ms")
    private Long generationTimeMs;

    /**
     * AI Token 消耗（输入 + 输出总量，仅 AI 生成时有效）
     */
    @Column(name = "tokens_used")
    private Integer tokensUsed;

    /**
     * 版本号（同一项目的 XSLT 可多次重新生成，递增版本号）
     */
    @Column(name = "version", nullable = false)
    @Builder.Default
    private Integer version = 1;

    /**
     * 是否为当前激活版本
     */
    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean isActive = true;
}

