package com.lens.migration.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
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
@TableName("migration_intent")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationIntent extends BaseEntity {

    /**
     * 所属迁移项目 ID
     */
    @TableField("project_id")
    private Long projectId;

    /**
     * 意图文档版本号（每次上传自动递增）
     */
    @TableField("version")
    @Builder.Default
    private Integer version = 1;

    /**
     * 意图文档文件名
     */
    @TableField("file_name")
    private String fileName;

    /**
     * 意图文档存储路径
     */
    @TableField("storage_path")
    private String storagePath;

    /**
     * 意图文档完整内容（Markdown 文本，直接存入数据库便于检索）
     */
    @TableField("content")
    private String content;

    /**
     * 解析后的迁移规则（JSON 数组，由 intent_parser.py 输出）
     * 格式示例：
     * [{"type":"RENAME","source_xpath":"...","target_xpath":"..."},...]
     */
    @TableField("parsed_rules")
    private String parsedRules;

    /**
     * 解析出的规则数量（冗余字段，便于快速统计）
     */
    @TableField("rules_count")
    private Integer rulesCount;

    /**
     * 是否为当前激活版本（用于生成时选择最新意图）
     */
    @TableField("is_active")
    @Builder.Default
    private Boolean isActive = true;

    /**
     * 备注
     */
    @TableField("remark")
    private String remark;
}
