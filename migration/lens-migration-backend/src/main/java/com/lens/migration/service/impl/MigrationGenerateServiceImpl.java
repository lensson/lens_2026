package com.lens.migration.service.impl;

import com.lens.migration.common.BusinessException;
import com.lens.migration.domain.MigrationArtifact;
import com.lens.migration.domain.MigrationTestCaseResult;
import com.lens.migration.domain.MigrationTestRun;
import com.lens.migration.domain.enums.ArtifactType;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.TestStatus;
import com.lens.migration.dto.MigrationGenerateDTO;
import com.lens.migration.mapper.MigrationArtifactMapper;
import com.lens.migration.mapper.MigrationTestCaseResultMapper;
import com.lens.migration.mapper.MigrationTestRunMapper;
import com.lens.migration.service.MigrationGenerateService;
import com.lens.migration.service.MigrationProjectService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class MigrationGenerateServiceImpl implements MigrationGenerateService {

    private final MigrationArtifactMapper artifactMapper;
    private final MigrationTestRunMapper testRunMapper;
    private final MigrationTestCaseResultMapper caseResultMapper;
    private final MigrationProjectService projectService;

    @Override
    @Transactional
    public MigrationGenerateDTO.ArtifactResponse generateXslt(MigrationGenerateDTO.GenerateRequest req) {
        // 验证项目存在
        projectService.getById(req.getProjectId());

        // 计算下一版本号
        MigrationArtifact existing = artifactMapper.selectLatestByProjectIdAndType(
                req.getProjectId(), ArtifactType.XSLT);
        int nextVersion = (existing == null) ? 1 : existing.getVersion() + 1;

        // 将旧版本设为非激活
        if (existing != null) {
            List<MigrationArtifact> all = artifactMapper.selectByProjectIdAndType(
                    req.getProjectId(), ArtifactType.XSLT);
            all.forEach(a -> {
                a.setIsActive(false);
                artifactMapper.updateById(a);
            });
        }

        // 更新项目状态为 GENERATING
        projectService.updateStatus(req.getProjectId(), MigrationStatus.GENERATING);

        // 创建产物占位记录（实际内容由 Python 服务回填）
        MigrationArtifact artifact = MigrationArtifact.builder()
                .projectId(req.getProjectId())
                .artifactType(ArtifactType.XSLT)
                .fileName("generated-transform-v" + nextVersion + ".xslt")
                .storagePath("/xslt/" + req.getProjectId() + "/v" + nextVersion + "/generated-transform.xslt")
                .version(nextVersion)
                .isActive(true)
                .build();
        artifactMapper.insert(artifact);

        log.info("XSLT 生成任务已创建: projectId={}, artifactId={}, version={}",
                req.getProjectId(), artifact.getId(), nextVersion);
        return toArtifactResponse(artifact);
    }

    @Override
    public MigrationGenerateDTO.ArtifactResponse getActiveXslt(Long projectId) {
        MigrationArtifact artifact = artifactMapper.selectActiveByProjectIdAndType(
                projectId, ArtifactType.XSLT);
        if (artifact == null)
            throw new BusinessException(404, "项目 " + projectId + " 无激活 XSLT 产物");
        return toArtifactResponse(artifact);
    }

    @Override
    public List<MigrationGenerateDTO.ArtifactResponse> listXsltVersions(Long projectId) {
        return artifactMapper.selectByProjectIdAndType(projectId, ArtifactType.XSLT).stream()
                .map(this::toArtifactResponse).toList();
    }

    @Override
    public MigrationGenerateDTO.ArtifactResponse getArtifactById(Long artifactId) {
        MigrationArtifact a = artifactMapper.selectById(artifactId);
        if (a == null) throw BusinessException.notFound("MigrationArtifact", artifactId);
        return toArtifactResponse(a);
    }

    @Override
    @Transactional
    public MigrationGenerateDTO.TestRunResponse runTests(MigrationGenerateDTO.RunTestRequest req) {
        projectService.getById(req.getProjectId());

        // 确定使用哪个 XSLT 产物
        MigrationArtifact artifact;
        if (req.getArtifactId() != null) {
            artifact = artifactMapper.selectById(req.getArtifactId());
            if (artifact == null) throw BusinessException.notFound("MigrationArtifact", req.getArtifactId());
        } else {
            artifact = artifactMapper.selectActiveByProjectIdAndType(req.getProjectId(), ArtifactType.XSLT);
            if (artifact == null)
                throw new BusinessException(404, "项目 " + req.getProjectId() + " 无可用 XSLT 产物，请先生成");
        }

        // 更新项目状态为 TESTING
        projectService.updateStatus(req.getProjectId(), MigrationStatus.TESTING);

        MigrationTestRun run = MigrationTestRun.builder()
                .projectId(req.getProjectId())
                .artifactId(artifact.getId())
                .status(TestStatus.RUNNING)
                .build();
        testRunMapper.insert(run);

        log.info("测试执行已创建: projectId={}, runId={}, artifactId={}",
                req.getProjectId(), run.getId(), artifact.getId());
        return toTestRunResponse(run);
    }

    @Override
    public MigrationGenerateDTO.TestRunResponse getLatestTestRun(Long projectId) {
        MigrationTestRun run = testRunMapper.selectLatestByProjectId(projectId);
        if (run == null)
            throw new BusinessException(404, "项目 " + projectId + " 无测试记录");
        return toTestRunResponse(run);
    }

    @Override
    public List<MigrationGenerateDTO.TestRunResponse> listTestRuns(Long projectId) {
        return testRunMapper.selectByProjectIdDesc(projectId).stream()
                .map(this::toTestRunResponse).toList();
    }

    @Override
    public MigrationGenerateDTO.TestRunDetail getTestRunDetail(Long testRunId) {
        MigrationTestRun run = testRunMapper.selectById(testRunId);
        if (run == null) throw BusinessException.notFound("MigrationTestRun", testRunId);

        List<MigrationGenerateDTO.CaseResultResponse> cases =
                caseResultMapper.selectByTestRunId(testRunId).stream()
                        .map(this::toCaseResponse).toList();

        MigrationGenerateDTO.TestRunDetail detail = new MigrationGenerateDTO.TestRunDetail();
        detail.setSummary(toTestRunResponse(run));
        detail.setCases(cases);
        return detail;
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private MigrationGenerateDTO.ArtifactResponse toArtifactResponse(MigrationArtifact a) {
        MigrationGenerateDTO.ArtifactResponse r = new MigrationGenerateDTO.ArtifactResponse();
        r.setId(a.getId());
        r.setProjectId(a.getProjectId());
        r.setIntentId(a.getIntentId());
        r.setArtifactType(a.getArtifactType());
        r.setFileName(a.getFileName());
        r.setStoragePath(a.getStoragePath());
        r.setContent(a.getContent());
        r.setGenerationTimeMs(a.getGenerationTimeMs());
        r.setTokensUsed(a.getTokensUsed());
        r.setVersion(a.getVersion());
        r.setIsActive(a.getIsActive());
        r.setCreatedAt(a.getCreatedAt());
        return r;
    }

    private MigrationGenerateDTO.TestRunResponse toTestRunResponse(MigrationTestRun run) {
        MigrationGenerateDTO.TestRunResponse r = new MigrationGenerateDTO.TestRunResponse();
        r.setId(run.getId());
        r.setProjectId(run.getProjectId());
        r.setArtifactId(run.getArtifactId());
        r.setStatus(run.getStatus());
        r.setTotalCases(run.getTotalCases());
        r.setPassedCases(run.getPassedCases());
        r.setFailedCases(run.getFailedCases());
        r.setErrorCases(run.getErrorCases());
        r.setDurationMs(run.getDurationMs());
        r.setErrorMessage(run.getErrorSummary());
        r.setCreatedAt(run.getCreatedAt());
        r.setUpdatedAt(run.getUpdatedAt());
        return r;
    }

    private MigrationGenerateDTO.CaseResultResponse toCaseResponse(MigrationTestCaseResult c) {
        MigrationGenerateDTO.CaseResultResponse r = new MigrationGenerateDTO.CaseResultResponse();
        r.setId(c.getId());
        r.setTestRunId(c.getTestRunId());
        r.setExampleId(c.getExampleId());
        r.setCaseName(c.getCaseName());
        r.setStatus(c.getStatus());
        r.setActualOutputPath(c.getActualOutputPath());
        r.setDiffDetail(c.getDiffDetail());
        r.setErrorMessage(c.getErrorMessage());
        r.setDurationMs(c.getDurationMs());
        r.setCreatedAt(c.getCreatedAt());
        return r;
    }
}

