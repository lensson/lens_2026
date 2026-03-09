package com.lens.migration.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
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
@TableName("migration_schema")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationSchema extends BaseEntity {

    /** 所属迁移项目 ID */
    @TableField("project_id")
    private Long projectId;

    /** Yang 文件名（如 "ietf-interfaces@2018-02-20.yang"） */
    @TableField("file_name")
    private String fileName;

    /** Yang 模块名称（如 "ietf-interfaces"） */
    @TableField("module_name")
    private String moduleName;

    /** Schema 版本标识（"source" = 旧版，"target" = 新版） */
    @TableField("schema_version")
    private String schemaVersion;

    /** 是否为 Deviation Yang（覆盖层，针对特定板卡的差异描述） */
    @TableField("is_deviation")
    @Builder.Default
    private Boolean isDeviation = false;

    /** 文件存储路径（相对于 storage.base-path） */
    @TableField("storage_path")
    private String storagePath;

    /** 文件大小（字节） */
    @TableField("file_size")
    private Long fileSize;

    /** 文件内容 MD5 校验值（防止重复上传） */
    @TableField("checksum")
    private String checksum;

    /** 备注（如 "主模块" / "板卡 lwlt-c 的 deviation 层"） */
    @TableField("remark")
    private String remark;
}
