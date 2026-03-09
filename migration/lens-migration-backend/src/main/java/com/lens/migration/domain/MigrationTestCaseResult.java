package com.lens.migration.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.lens.migration.domain.enums.TestStatus;
import lombok.*;

/**
 * 单个测试用例结果（migration_test_case_result）
 *
 * 一个 TestRun 中每个 XML 样本对的验证结果明细。
 *
 * 数据库：auto_migration
 * 表名：migration_test_case_result
 */
@TableName("migration_test_case_result")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MigrationTestCaseResult extends BaseEntity {

    /** 所属测试执行批次 ID */
    @TableField("test_run_id")
    private Long testRunId;

    /** 对应的 XML 样本对 ID */
    @TableField("example_id")
    private Long exampleId;

    /** 用例名称（来自 MigrationExample.sampleName） */
    @TableField("case_name")
    private String caseName;

    /** 执行结果 */
    @TableField("status")
    private TestStatus status;

    /** 实际 XSLT 转换输出的 XML 存储路径 */
    @TableField("actual_output_path")
    private String actualOutputPath;

    /** 差异详情（expected vs actual，文本 diff 格式），仅当 status = FAILED 时有内容 */
    @TableField("diff_detail")
    private String diffDetail;

    /** 错误信息（当 status = ERROR 时，记录异常堆栈或错误描述） */
    @TableField("error_message")
    private String errorMessage;

    /** 用例执行耗时（毫秒） */
    @TableField("duration_ms")
    private Long durationMs;
}
