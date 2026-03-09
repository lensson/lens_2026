package com.lens.migration.domain;

import com.lens.migration.domain.enums.TestStatus;
import jakarta.persistence.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

/**
 * 测试执行记录（migration_test_run）
 *
 * 每次触发自动化测试对应一条 TestRun 记录。
 * 一个 TestRun 包含多个 TestCaseResult（每个样本对的验证结果）。
 *
 * 数据库：auto_migration
 * 表名：migration_test_run
 */
@Entity
@Table(name = "migration_test_run", indexes = {
    @Index(name = "idx_test_run_project_id", columnList = "project_id"),
    @Index(name = "idx_test_run_artifact_id", columnList = "artifact_id"),
    @Index(name = "idx_test_run_status", columnList = "status")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationTestRun extends BaseEntity {

    /**
     * 所属迁移项目
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "project_id", nullable = false)
    private MigrationProject project;

    /**
     * 被测 XSLT 产物
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "artifact_id", nullable = false)
    private MigrationArtifact artifact;

    /**
     * 测试执行状态
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    @Builder.Default
    private TestStatus status = TestStatus.RUNNING;

    /**
     * 总用例数
     */
    @Column(name = "total_cases")
    @Builder.Default
    private Integer totalCases = 0;

    /**
     * 通过用例数
     */
    @Column(name = "passed_cases")
    @Builder.Default
    private Integer passedCases = 0;

    /**
     * 失败用例数
     */
    @Column(name = "failed_cases")
    @Builder.Default
    private Integer failedCases = 0;

    /**
     * 出错用例数（运行时异常）
     */
    @Column(name = "error_cases")
    @Builder.Default
    private Integer errorCases = 0;

    /**
     * 测试执行耗时（毫秒）
     */
    @Column(name = "duration_ms")
    private Long durationMs;

    /**
     * Python pytest 输出的原始报告内容（JSON 或文本）
     */
    @Column(name = "raw_report", columnDefinition = "TEXT")
    private String rawReport;

    /**
     * 错误摘要（当 status = FAILED / ERROR 时记录关键错误信息）
     */
    @Column(name = "error_summary", length = 2000)
    private String errorSummary;

    /**
     * 子用例结果列表（一对多）
     */
    @OneToMany(mappedBy = "testRun", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    @Builder.Default
    private List<MigrationTestCaseResult> caseResults = new ArrayList<>();
}

