package com.lens.migration.domain;

import com.lens.migration.domain.enums.TestStatus;
import jakarta.persistence.*;
import lombok.*;

/**
 * 单个测试用例结果（migration_test_case_result）
 *
 * 一个 TestRun 中每个 XML 样本对的验证结果明细。
 * 记录每条用例的执行状态、差异信息和实际产出路径。
 *
 * 数据库：auto_migration
 * 表名：migration_test_case_result
 */
@Entity
@Table(name = "migration_test_case_result", indexes = {
    @Index(name = "idx_case_result_run_id", columnList = "test_run_id"),
    @Index(name = "idx_case_result_example_id", columnList = "example_id"),
    @Index(name = "idx_case_result_status", columnList = "status")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationTestCaseResult extends BaseEntity {

    /**
     * 所属测试执行批次
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "test_run_id", nullable = false)
    private MigrationTestRun testRun;

    /**
     * 对应的 XML 样本对
     */
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "example_id", nullable = false)
    private MigrationExample example;

    /**
     * 用例名称（来自 example.sampleName）
     */
    @Column(name = "case_name", nullable = false, length = 200)
    private String caseName;

    /**
     * 执行结果
     */
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private TestStatus status;

    /**
     * 实际 XSLT 转换输出的 XML 存储路径
     */
    @Column(name = "actual_output_path", length = 500)
    private String actualOutputPath;

    /**
     * 差异详情（expected vs actual，文本 diff 格式）
     * 仅当 status = FAILED 时有内容
     */
    @Column(name = "diff_detail", columnDefinition = "TEXT")
    private String diffDetail;

    /**
     * 错误信息（当 status = ERROR 时，记录异常堆栈或错误描述）
     */
    @Column(name = "error_message", length = 2000)
    private String errorMessage;

    /**
     * 用例执行耗时（毫秒）
     */
    @Column(name = "duration_ms")
    private Long durationMs;
}

