package com.lens.migration.repository;

import com.lens.migration.domain.MigrationExample;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * XML 样本对 Repository
 */
@Repository
public interface MigrationExampleRepository extends JpaRepository<MigrationExample, Long> {

    List<MigrationExample> findByProjectId(Long projectId);

    List<MigrationExample> findByProjectIdAndOperationType(Long projectId, String operationType);
}

