package com.lens.migration.domain;

import jakarta.persistence.*;
import lombok.*;

/**
 * 迁移意图文档记录（migration_intent）
 *
 * 存储用户上传的迁移意图 Markdown 文档，以及解析后的规则 JSON。
 * 意图文档描述了"应该做什么"，是 XSLT 生成的核心输入之一。
 *
 * 支持多版本（同一项目可多次上传意图文档，取最新版本生成）。
 *
 * 数据库：auto_migration
 * 表名：migration_intent
 */
@Entity
@Table(name = "migration_intent", indexes = {
    @Index(name = "idx_intent_project_id", columnList = "project_id"),
    @Index(name = "idx_intent_version", columnList = "project_id, version")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationIntent extends BaseEntity {

    /**
     * 所属迁移项目
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "project_id", nullable = false)
    private MigrationProject project;

    /**
     * 意图文档版本号（每次上传自动递增）
     */
    @Column(name = "version", nullable = false)
    @Builder.Default
    private Integer version = 1;

    /**
     * 意图文档文件名
     */
    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;

    /**
     * 意图文档存储路径
     */
    @Column(name = "storage_path", nullable = false, length = 500)
    private String storagePath;

    /**
     * 意图文档完整内容（Markdown 文本，直接存入数据库便于检索）
     * 使用 TEXT 类型，支持较长内容
     */
    @Column(name = "content", columnDefinition = "TEXT")
    private String content;

    /**
     * 解析后的迁移规则（JSON 数组，由 intent_parser.py 输出）
     * 格式示例：
     * [{"type":"RENAME","source_xpath":"...","target_xpath":"..."},...]
     */
    @Column(name = "parsed_rules", columnDefinition = "TEXT")
    private String parsedRules;

    /**
     * 解析出的规则数量（冗余字段，便于快速统计）
     */
    @Column(name = "rules_count")
    private Integer rulesCount;

    /**
     * 是否为当前激活版本（用于生成时选择最新意图）
     */
    @Column(name = "is_active", nullable = false)
    @Builder.Default
    private Boolean isActive = true;

    /**
     * 备注
     */
    @Column(name = "remark", length = 500)
    private String remark;
}

