package com.lens.migration.service;

import com.lens.migration.dto.MigrationGenerateDTO;

import java.util.List;

/**
 * XSLT 生成 & 测试执行服务接口
 */
public interface MigrationGenerateService {

    /**
     * 触发 XSLT 生成（异步，立即返回 artifact 占位记录）
     * 实际生成由 lens-migration-core Python 服务执行，此处记录入库并更新状态
     */
    MigrationGenerateDTO.ArtifactResponse generateXslt(MigrationGenerateDTO.GenerateRequest req);

    /** 查询最新激活 XSLT 产物 */
    MigrationGenerateDTO.ArtifactResponse getActiveXslt(Long projectId);

    /** 查询项目所有 XSLT 版本 */
    List<MigrationGenerateDTO.ArtifactResponse> listXsltVersions(Long projectId);

    /** 按 artifact ID 查询产物详情 */
    MigrationGenerateDTO.ArtifactResponse getArtifactById(Long artifactId);

    /**
     * 触发测试执行
     * 对项目下所有 XML 样本对依次用 XSLT 变换，比对期望输出
     */
    MigrationGenerateDTO.TestRunResponse runTests(MigrationGenerateDTO.RunTestRequest req);

    /** 查询项目最新测试结果 */
    MigrationGenerateDTO.TestRunResponse getLatestTestRun(Long projectId);

    /** 查询项目所有测试批次 */
    List<MigrationGenerateDTO.TestRunResponse> listTestRuns(Long projectId);

    /** 查询测试批次详情（含用例明细） */
    MigrationGenerateDTO.TestRunDetail getTestRunDetail(Long testRunId);
}

