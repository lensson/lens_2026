package com.lens.migration.domain;

import jakarta.persistence.*;
import lombok.*;

/**
 * Yang Schema 上传记录（migration_schema）
 *
 * 记录每次上传的 Yang Schema 文件信息。
 * 一个迁移项目可以有多个 Yang 文件（如模块 Yang + deviation Yang）。
 *
 * 数据库：auto_migration
 * 表名：migration_schema
 */
@Entity
@Table(name = "migration_schema", indexes = {
    @Index(name = "idx_schema_project_id", columnList = "project_id"),
    @Index(name = "idx_schema_version", columnList = "schema_version")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationSchema extends BaseEntity {

    /**
     * 所属迁移项目
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "project_id", nullable = false)
    private MigrationProject project;

    /**
     * Yang 文件名（如 "ietf-interfaces@2018-02-20.yang"）
     */
    @Column(name = "file_name", nullable = false, length = 255)
    private String fileName;

    /**
     * Yang 模块名称（如 "ietf-interfaces"）
     */
    @Column(name = "module_name", length = 200)
    private String moduleName;

    /**
     * Schema 版本标识（"source" = 旧版，"target" = 新版）
     */
    @Column(name = "schema_version", nullable = false, length = 20)
    private String schemaVersion;

    /**
     * 是否为 Deviation Yang（覆盖层，针对特定板卡的差异描述）
     */
    @Column(name = "is_deviation", nullable = false)
    @Builder.Default
    private Boolean isDeviation = false;

    /**
     * 文件存储路径（相对于 storage.base-path）
     */
    @Column(name = "storage_path", nullable = false, length = 500)
    private String storagePath;

    /**
     * 文件大小（字节）
     */
    @Column(name = "file_size")
    private Long fileSize;

    /**
     * 文件内容 MD5 校验值（防止重复上传）
     */
    @Column(name = "checksum", length = 64)
    private String checksum;

    /**
     * 备注（如 "主模块" / "板卡 lwlt-c 的 deviation 层"）
     */
    @Column(name = "remark", length = 500)
    private String remark;
}

