package com.lens.migration.domain.enums;

/**
 * 测试结果状态枚举
 */
public enum TestStatus {

    /** 测试进行中 */
    RUNNING,

    /** 测试通过 */
    PASSED,

    /** 测试失败（转换输出与期望不符） */
    FAILED,

    /** 测试出错（XSLT 语法错误、执行异常等） */
    ERROR,

    /** 已跳过 */
    SKIPPED
}

