package com.lens.migration.repository;

import com.lens.migration.domain.MigrationTestCaseResult;
import com.lens.migration.domain.enums.TestStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * 测试用例结果 Repository
 */
@Repository
public interface MigrationTestCaseResultRepository extends JpaRepository<MigrationTestCaseResult, Long> {

    List<MigrationTestCaseResult> findByTestRunId(Long testRunId);

    List<MigrationTestCaseResult> findByTestRunIdAndStatus(Long testRunId, TestStatus status);
}

