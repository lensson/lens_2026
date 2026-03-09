package com.lens.migration.repository;

import com.lens.migration.domain.MigrationIntent;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * 意图文档 Repository
 */
@Repository
public interface MigrationIntentRepository extends JpaRepository<MigrationIntent, Long> {

    List<MigrationIntent> findByProjectIdOrderByVersionDesc(Long projectId);

    /** 查询当前激活版本的意图文档 */
    Optional<MigrationIntent> findByProjectIdAndIsActiveTrue(Long projectId);

    /** 查询最新版本号 */
    Optional<MigrationIntent> findTopByProjectIdOrderByVersionDesc(Long projectId);
}

