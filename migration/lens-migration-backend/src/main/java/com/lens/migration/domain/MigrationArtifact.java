package com.lens.migration.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.lens.migration.domain.enums.ArtifactType;
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
@TableName("migration_artifact")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationArtifact extends BaseEntity {

    /** 所属迁移项目 ID */
    @TableField("project_id")
    private Long projectId;

    /** 关联的意图文档 ID（生成此产物时使用的意图版本，可为空） */
    @TableField("intent_id")
    private Long intentId;

    /** 产物类型 */
    @TableField("artifact_type")
    private ArtifactType artifactType;

    /** 产物文件名 */
    @TableField("file_name")
    private String fileName;

    /** 产物存储路径（相对于 storage.base-path） */
    @TableField("storage_path")
    private String storagePath;

    /** 文件大小（字节） */
    @TableField("file_size")
    private Long fileSize;

    /** 产物内容（对于 XSLT 和小型 XML，直接存入数据库便于快速预览） */
    @TableField("content")
    private String content;

    /** AI 生成时的对话历史（JSON 格式，记录每轮 prompt + response） */
    @TableField("ai_conversation_history")
    private String aiConversationHistory;

    /** 生成耗时（毫秒） */
    @TableField("generation_time_ms")
    private Long generationTimeMs;

    /** AI Token 消耗（输入 + 输出总量，仅 AI 生成时有效） */
    @TableField("tokens_used")
    private Integer tokensUsed;

    /** 版本号（同一项目的 XSLT 可多次重新生成，递增版本号） */
    @TableField("version")
    @Builder.Default
    private Integer version = 1;

    /** 是否为当前激活版本 */
    @TableField("is_active")
    @Builder.Default
    private Boolean isActive = true;
}
