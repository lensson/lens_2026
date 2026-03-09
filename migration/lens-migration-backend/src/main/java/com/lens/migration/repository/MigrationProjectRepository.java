package com.lens.migration.repository;

import com.lens.migration.domain.MigrationProject;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 迁移项目 Repository
 */
@Repository
public interface MigrationProjectRepository extends JpaRepository<MigrationProject, Long> {

    /** 按状态查询 */
    List<MigrationProject> findByStatus(MigrationStatus status);

    /** 按设备型号查询 */
    List<MigrationProject> findByDeviceModel(String deviceModel);

    /** 按创建人查询 */
    List<MigrationProject> findByCreatedBy(String createdBy);

    /** 按设备型号 + 版本范围查询 */
    List<MigrationProject> findByDeviceModelAndSourceVersionAndTargetVersion(
            String deviceModel, String sourceVersion, String targetVersion);

    /** 按迁移类型查询 */
    List<MigrationProject> findByMigrationType(MigrationType migrationType);

    /** 统计各状态项目数量 */
    @Query("SELECT p.status, COUNT(p) FROM MigrationProject p GROUP BY p.status")
    List<Object[]> countByStatus();

    /** 按名称模糊搜索 */
    @Query("SELECT p FROM MigrationProject p WHERE p.name LIKE %:keyword% OR p.description LIKE %:keyword%")
    List<MigrationProject> searchByKeyword(@Param("keyword") String keyword);
}

