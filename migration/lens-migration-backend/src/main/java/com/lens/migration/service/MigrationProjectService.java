package com.lens.migration.service;

import com.lens.migration.common.PageResult;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.dto.MigrationProjectDTO;

/**
 * 迁移项目服务接口
 */
public interface MigrationProjectService {

    /** 创建迁移项目 */
    MigrationProjectDTO.Response create(MigrationProjectDTO.CreateRequest req, String createdBy);

    /** 按 ID 查询 */
    MigrationProjectDTO.Response getById(Long id);

    /** 分页查询（支持按状态、类型过滤） */
    PageResult<MigrationProjectDTO.ListItem> list(int page, int size,
                                                   MigrationStatus status,
                                                   MigrationType migrationType,
                                                   String keyword);

    /** 更新项目信息 */
    MigrationProjectDTO.Response update(Long id, MigrationProjectDTO.UpdateRequest req);

    /** 删除项目（级联删除关联数据） */
    void delete(Long id);

    /** 更新项目状态 */
    void updateStatus(Long id, MigrationStatus status);

    /** 更新项目状态（带错误信息） */
    void updateStatusWithError(Long id, MigrationStatus status, String errorMessage);
}

