package com.lens.migration.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lens.migration.domain.MigrationProject;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * 迁移项目 Mapper
 *
 * 继承 BaseMapper 获得完整 CRUD。
 * 自定义查询方法通过注解 SQL 实现。
 */
@Mapper
public interface MigrationProjectMapper extends BaseMapper<MigrationProject> {

    /** 按状态查询 */
    @Select("SELECT * FROM migration_project WHERE status = #{status}")
    List<MigrationProject> selectByStatus(@Param("status") MigrationStatus status);

    /** 按设备型号查询 */
    @Select("SELECT * FROM migration_project WHERE device_model = #{deviceModel}")
    List<MigrationProject> selectByDeviceModel(@Param("deviceModel") String deviceModel);

    /** 按创建人查询 */
    @Select("SELECT * FROM migration_project WHERE created_by = #{createdBy}")
    List<MigrationProject> selectByCreatedBy(@Param("createdBy") String createdBy);

    /** 按迁移类型查询 */
    @Select("SELECT * FROM migration_project WHERE migration_type = #{migrationType}")
    List<MigrationProject> selectByMigrationType(@Param("migrationType") MigrationType migrationType);

    /** 按关键字模糊搜索（name 或 description） */
    @Select("SELECT * FROM migration_project WHERE name LIKE CONCAT('%',#{keyword},'%') OR description LIKE CONCAT('%',#{keyword},'%')")
    List<MigrationProject> searchByKeyword(@Param("keyword") String keyword);

    /** 按设备型号 + 源版本 + 目标版本精确查询 */
    @Select("SELECT * FROM migration_project WHERE device_model=#{deviceModel} AND source_version=#{sourceVersion} AND target_version=#{targetVersion}")
    List<MigrationProject> selectByDeviceAndVersions(
            @Param("deviceModel") String deviceModel,
            @Param("sourceVersion") String sourceVersion,
            @Param("targetVersion") String targetVersion);
}

