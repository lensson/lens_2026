package com.lens.migration.service;

import com.lens.migration.dto.MigrationSchemaDTO;

import java.util.List;

/**
 * Yang Schema 服务接口
 */
public interface MigrationSchemaService {

    /** 添加一条 Schema 记录 */
    MigrationSchemaDTO.Response add(MigrationSchemaDTO.CreateRequest req);

    /** 按项目查询所有 Schema */
    List<MigrationSchemaDTO.Response> listByProject(Long projectId);

    /** 按项目和版本查询（source / target） */
    List<MigrationSchemaDTO.Response> listByProjectAndVersion(Long projectId, String schemaVersion);

    /** 删除 Schema 记录 */
    void delete(Long id);

    /** 按 ID 查询 */
    MigrationSchemaDTO.Response getById(Long id);
}

