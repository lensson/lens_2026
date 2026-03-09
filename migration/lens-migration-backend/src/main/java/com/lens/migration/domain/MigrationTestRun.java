package com.lens.migration.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.lens.migration.domain.enums.TestStatus;
import lombok.*;

/**
 * 测试执行记录（migration_test_run）
 *
 * 每次触发自动化测试对应一条 TestRun 记录。
 * 一个 TestRun 包含多个 MigrationTestCaseResult（每个样本对的验证结果）。
 *
 * 数据库：auto_migration
 * 表名：migration_test_run
 */
@TableName("migration_test_run")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationTestRun extends BaseEntity {

    /** 所属迁移项目 ID */
    @TableField("project_id")
    private Long projectId;

    /** 被测 XSLT 产物 ID */
    @TableField("artifact_id")
    private Long artifactId;

    /** 测试执行状态 */
    @TableField("status")
    @Builder.Default
    private TestStatus status = TestStatus.RUNNING;

    /** 总用例数 */
    @TableField("total_cases")
    @Builder.Default
    private Integer totalCases = 0;

    /** 通过用例数 */
    @TableField("passed_cases")
    @Builder.Default
    private Integer passedCases = 0;

    /** 失败用例数 */
    @TableField("failed_cases")
    @Builder.Default
    private Integer failedCases = 0;

    /** 出错用例数（运行时异常） */
    @TableField("error_cases")
    @Builder.Default
    private Integer errorCases = 0;

    /** 测试执行耗时（毫秒） */
    @TableField("duration_ms")
    private Long durationMs;

    /** Python pytest 输出的原始报告内容（JSON 或文本） */
    @TableField("raw_report")
    private String rawReport;

    /** 错误摘要（当 status = FAILED / ERROR 时记录关键错误信息） */
    @TableField("error_summary")
    private String errorSummary;
}
