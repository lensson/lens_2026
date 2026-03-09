package com.lens.migration.repository;

import com.lens.migration.domain.MigrationSchema;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Yang Schema Repository
 */
@Repository
public interface MigrationSchemaRepository extends JpaRepository<MigrationSchema, Long> {

    List<MigrationSchema> findByProjectId(Long projectId);

    List<MigrationSchema> findByProjectIdAndSchemaVersion(Long projectId, String schemaVersion);

    List<MigrationSchema> findByProjectIdAndIsDeviation(Long projectId, Boolean isDeviation);

    Optional<MigrationSchema> findByProjectIdAndChecksum(Long projectId, String checksum);
}

