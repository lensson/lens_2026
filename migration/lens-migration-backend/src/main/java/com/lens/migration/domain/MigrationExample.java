package com.lens.migration.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.*;

/**
 * XML 样本对记录（migration_example）
 *
 * 记录一组输入 XML（旧版本）与期望输出 XML（新版本）的配对样本。
 *
 * 数据库：auto_migration
 * 表名：migration_example
 */
@TableName("migration_example")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationExample extends BaseEntity {

    /** 所属迁移项目 ID */
    @TableField("project_id")
    private Long projectId;

    /** 样本组名称（如 "sample-01"、"vlan-create-001"） */
    @TableField("sample_name")
    private String sampleName;

    /** Netconf 操作类型（create / edit-config / delete / get / get-config） */
    @TableField("operation_type")
    private String operationType;

    /** 输入 XML 文件名（旧版本 Datastore XML） */
    @TableField("input_file_name")
    private String inputFileName;

    /** 输入 XML 存储路径 */
    @TableField("input_storage_path")
    private String inputStoragePath;

    /** 期望输出 XML 文件名（新版本 Datastore XML） */
    @TableField("expected_file_name")
    private String expectedFileName;

    /** 期望输出 XML 存储路径 */
    @TableField("expected_storage_path")
    private String expectedStoragePath;

    /** XPath 根节点（如 "classifiers"、"interfaces"） */
    @TableField("root_xpath")
    private String rootXpath;

    /** XML 命名空间前缀映射（JSON 格式，如 {"bbf":"urn:broadband-forum-org:yang:bbf-classifiers"}） */
    @TableField("namespace_map")
    private String namespaceMap;

    /** 备注（描述该样本的用途和特殊性） */
    @TableField("remark")
    private String remark;
}
