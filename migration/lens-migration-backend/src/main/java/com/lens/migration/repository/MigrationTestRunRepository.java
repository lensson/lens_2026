package com.lens.migration.repository;

import com.lens.migration.domain.MigrationTestRun;
import com.lens.migration.domain.enums.TestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 测试执行记录 Repository
 */
@Repository
public interface MigrationTestRunRepository extends JpaRepository<MigrationTestRun, Long> {

    List<MigrationTestRun> findByProjectIdOrderByCreatedAtDesc(Long projectId);

    List<MigrationTestRun> findByProjectIdAndStatus(Long projectId, TestStatus status);

    /** 查询项目最新一次测试执行 */
    Optional<MigrationTestRun> findTopByProjectIdOrderByCreatedAtDesc(Long projectId);

    List<MigrationTestRun> findByArtifactId(Long artifactId);
}

