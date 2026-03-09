package com.lens.migration.service;

import com.lens.migration.dto.MigrationExampleDTO;

import java.util.List;

/**
 * XML 样本对服务接口
 */
public interface MigrationExampleService {

    /** 添加样本对 */
    MigrationExampleDTO.Response add(MigrationExampleDTO.CreateRequest req);

    /** 按项目查询所有样本对 */
    List<MigrationExampleDTO.Response> listByProject(Long projectId);

    /** 按项目和操作类型查询 */
    List<MigrationExampleDTO.Response> listByProjectAndOperation(Long projectId, String operationType);

    /** 按 ID 查询 */
    MigrationExampleDTO.Response getById(Long id);

    /** 删除样本对 */
    void delete(Long id);
}

