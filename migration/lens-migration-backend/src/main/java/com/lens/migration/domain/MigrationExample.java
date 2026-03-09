package com.lens.migration.domain;

import jakarta.persistence.*;
import lombok.*;

/**
 * XML 样本对记录（migration_example）
 *
 * 记录一组输入 XML（旧版本）与期望输出 XML（新版本）的配对样本。
 * 用于：
 * 1. 构建 AI Prompt 中的 few-shot 示例
 * 2. XSLT 生成后的验证对比
 *
 * 一个迁移项目可包含多组样本对（按设备操作类型区分：create / edit / delete / get）。
 *
 * 数据库：auto_migration
 * 表名：migration_example
 */
@Entity
@Table(name = "migration_example", indexes = {
    @Index(name = "idx_example_project_id", columnList = "project_id"),
    @Index(name = "idx_example_operation", columnList = "operation_type")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationExample extends BaseEntity {

    /**
     * 所属迁移项目
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "project_id", nullable = false)
    private MigrationProject project;

    /**
     * 样本组名称（如 "sample-01"、"vlan-create-001"）
     */
    @Column(name = "sample_name", nullable = false, length = 200)
    private String sampleName;

    /**
     * Netconf 操作类型（create / edit-config / delete / get / get-config）
     */
    @Column(name = "operation_type", length = 50)
    private String operationType;

    /**
     * 输入 XML 文件名（旧版本 Datastore XML）
     */
    @Column(name = "input_file_name", nullable = false, length = 255)
    private String inputFileName;

    /**
     * 输入 XML 存储路径
     */
    @Column(name = "input_storage_path", nullable = false, length = 500)
    private String inputStoragePath;

    /**
     * 期望输出 XML 文件名（新版本 Datastore XML）
     */
    @Column(name = "expected_file_name", nullable = false, length = 255)
    private String expectedFileName;

    /**
     * 期望输出 XML 存储路径
     */
    @Column(name = "expected_storage_path", nullable = false, length = 500)
    private String expectedStoragePath;

    /**
     * XPath 根节点（如 "classifiers"、"interfaces"）
     */
    @Column(name = "root_xpath", length = 200)
    private String rootXpath;

    /**
     * XML 命名空间前缀映射（JSON 格式，如 {"bbf":"urn:broadband-forum-org:yang:bbf-classifiers"}）
     */
    @Column(name = "namespace_map", length = 2000)
    private String namespaceMap;

    /**
     * 备注（描述该样本的用途和特殊性）
     */
    @Column(name = "remark", length = 500)
    private String remark;
}

