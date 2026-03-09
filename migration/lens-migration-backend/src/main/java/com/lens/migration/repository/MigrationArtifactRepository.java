package com.lens.migration.repository;

import com.lens.migration.domain.MigrationArtifact;
import com.lens.migration.domain.enums.ArtifactType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 迁移产物 Repository
 */
@Repository
public interface MigrationArtifactRepository extends JpaRepository<MigrationArtifact, Long> {

    List<MigrationArtifact> findByProjectId(Long projectId);

    List<MigrationArtifact> findByProjectIdAndArtifactType(Long projectId, ArtifactType artifactType);

    /** 查询当前激活版本的 XSLT */
    Optional<MigrationArtifact> findByProjectIdAndArtifactTypeAndIsActiveTrue(
            Long projectId, ArtifactType artifactType);

    /** 查询最新版本号 */
    Optional<MigrationArtifact> findTopByProjectIdAndArtifactTypeOrderByVersionDesc(
            Long projectId, ArtifactType artifactType);
}

