package com.lens.migration.service;

import com.lens.migration.dto.MigrationIntentDTO;

import java.util.List;

/**
 * 迁移意图文档服务接口
 */
public interface MigrationIntentService {

    /**
     * 上传意图文档（自动递增版本，将之前版本设为非激活）
     */
    MigrationIntentDTO.Response upload(MigrationIntentDTO.CreateRequest req);

    /** 查询项目所有版本（倒序） */
    List<MigrationIntentDTO.Response> listByProject(Long projectId);

    /** 查询激活版本 */
    MigrationIntentDTO.Response getActive(Long projectId);

    /** 查询最新版本 */
    MigrationIntentDTO.Response getLatest(Long projectId);

    /** 按 ID 查询 */
    MigrationIntentDTO.Response getById(Long id);

    /** 激活指定版本（取消其他版本激活） */
    void activate(Long id);

    /** 删除版本 */
    void delete(Long id);
}

