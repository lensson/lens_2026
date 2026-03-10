package com.lens.migration.service;

import com.lens.migration.common.BusinessException;
import com.lens.migration.domain.MigrationArtifact;
import com.lens.migration.domain.MigrationTestCaseResult;
import com.lens.migration.domain.MigrationTestRun;
import com.lens.migration.domain.enums.ArtifactType;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.TestStatus;
import com.lens.migration.dto.MigrationGenerateDTO;
import com.lens.migration.dto.MigrationProjectDTO;
import com.lens.migration.mapper.MigrationArtifactMapper;
import com.lens.migration.mapper.MigrationTestCaseResultMapper;
import com.lens.migration.mapper.MigrationTestRunMapper;
import com.lens.migration.service.impl.MigrationGenerateServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("MigrationGenerateService 单元测试")
class MigrationGenerateServiceTest {

    @Mock private MigrationArtifactMapper artifactMapper;
    @Mock private MigrationTestRunMapper testRunMapper;
    @Mock private MigrationTestCaseResultMapper caseResultMapper;
    @Mock private MigrationProjectService projectService;

    @InjectMocks
    private MigrationGenerateServiceImpl generateService;

    private MigrationArtifact sampleArtifact;
    private MigrationTestRun sampleRun;
    private MigrationProjectDTO.Response sampleProject;

    @BeforeEach
    void setUp() {
        sampleArtifact = MigrationArtifact.builder()
                .projectId(1L)
                .artifactType(ArtifactType.XSLT)
                .fileName("generated-transform-v1.xslt")
                .storagePath("/xslt/1/v1/generated-transform.xslt")
                .version(1)
                .isActive(true)
                .build();
        sampleArtifact.setId(40L);
        sampleArtifact.setCreatedAt(LocalDateTime.now());

        sampleRun = MigrationTestRun.builder()
                .projectId(1L)
                .artifactId(40L)
                .status(TestStatus.RUNNING)
                .totalCases(0)
                .passedCases(0)
                .failedCases(0)
                .errorCases(0)
                .build();
        sampleRun.setId(50L);
        sampleRun.setCreatedAt(LocalDateTime.now());
        sampleRun.setUpdatedAt(LocalDateTime.now());

        sampleProject = new MigrationProjectDTO.Response();
        sampleProject.setId(1L);
        sampleProject.setStatus(MigrationStatus.CREATED);
    }

    // ── generateXslt ──────────────────────────────────────────────────────────

    @Test
    @DisplayName("首次生成 XSLT：版本为1，isActive=true，项目状态变为 GENERATING")
    void generateXslt_firstTime_versionOne() {
        when(projectService.getById(1L)).thenReturn(sampleProject);
        when(artifactMapper.selectLatestByProjectIdAndType(1L, ArtifactType.XSLT))
                .thenReturn(null);
        doAnswer(inv -> {
            MigrationArtifact a = inv.getArgument(0);
            a.setId(40L);
            a.setCreatedAt(LocalDateTime.now());
            return 1;
        }).when(artifactMapper).insert(any(MigrationArtifact.class));

        MigrationGenerateDTO.GenerateRequest req = new MigrationGenerateDTO.GenerateRequest();
        req.setProjectId(1L);

        MigrationGenerateDTO.ArtifactResponse resp = generateService.generateXslt(req);

        assertThat(resp.getVersion()).isEqualTo(1);
        assertThat(resp.getIsActive()).isTrue();
        assertThat(resp.getArtifactType()).isEqualTo(ArtifactType.XSLT);
        // 项目状态应更新为 GENERATING
        verify(projectService).updateStatus(1L, MigrationStatus.GENERATING);
        verify(artifactMapper).insert(any(MigrationArtifact.class));
    }

    @Test
    @DisplayName("重新生成 XSLT：版本递增，旧版本设为非激活")
    void generateXslt_regenerate_versionIncrementsAndOldDeactivated() {
        when(projectService.getById(1L)).thenReturn(sampleProject);
        when(artifactMapper.selectLatestByProjectIdAndType(1L, ArtifactType.XSLT))
                .thenReturn(sampleArtifact); // 已存在 v1
        when(artifactMapper.selectByProjectIdAndType(1L, ArtifactType.XSLT))
                .thenReturn(List.of(sampleArtifact));
        doAnswer(inv -> {
            MigrationArtifact a = inv.getArgument(0);
            a.setId(41L);
            a.setCreatedAt(LocalDateTime.now());
            return 1;
        }).when(artifactMapper).insert(any(MigrationArtifact.class));

        MigrationGenerateDTO.GenerateRequest req = new MigrationGenerateDTO.GenerateRequest();
        req.setProjectId(1L);

        MigrationGenerateDTO.ArtifactResponse resp = generateService.generateXslt(req);

        assertThat(resp.getVersion()).isEqualTo(2);
        // 旧版本应被设为非激活
        verify(artifactMapper).updateById(argThat((MigrationArtifact a) -> !a.getIsActive()));
    }

    @Test
    @DisplayName("生成 XSLT：项目不存在时抛出 404")
    void generateXslt_projectNotFound_throwsException() {
        when(projectService.getById(99L)).thenThrow(BusinessException.notFound("MigrationProject", 99L));

        MigrationGenerateDTO.GenerateRequest req = new MigrationGenerateDTO.GenerateRequest();
        req.setProjectId(99L);

        assertThatThrownBy(() -> generateService.generateXslt(req))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    // ── getActiveXslt ─────────────────────────────────────────────────────────

    @Test
    @DisplayName("查询激活 XSLT：存在时正确返回")
    void getActiveXslt_found_returnsArtifact() {
        when(artifactMapper.selectActiveByProjectIdAndType(1L, ArtifactType.XSLT))
                .thenReturn(sampleArtifact);

        MigrationGenerateDTO.ArtifactResponse resp = generateService.getActiveXslt(1L);

        assertThat(resp.getId()).isEqualTo(40L);
        assertThat(resp.getIsActive()).isTrue();
    }

    @Test
    @DisplayName("查询激活 XSLT：无产物时抛出 404")
    void getActiveXslt_notFound_throwsException() {
        when(artifactMapper.selectActiveByProjectIdAndType(1L, ArtifactType.XSLT))
                .thenReturn(null);

        assertThatThrownBy(() -> generateService.getActiveXslt(1L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    // ── listXsltVersions ──────────────────────────────────────────────────────

    @Test
    @DisplayName("查询所有 XSLT 版本：返回列表")
    void listXsltVersions_returnsList() {
        when(artifactMapper.selectByProjectIdAndType(1L, ArtifactType.XSLT))
                .thenReturn(List.of(sampleArtifact));

        List<MigrationGenerateDTO.ArtifactResponse> result = generateService.listXsltVersions(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getVersion()).isEqualTo(1);
    }

    // ── runTests ──────────────────────────────────────────────────────────────

    @Test
    @DisplayName("触发测试：使用激活 XSLT 创建 TestRun，状态为 RUNNING")
    void runTests_usesActiveArtifact_createsRunning() {
        when(projectService.getById(1L)).thenReturn(sampleProject);
        when(artifactMapper.selectActiveByProjectIdAndType(1L, ArtifactType.XSLT))
                .thenReturn(sampleArtifact);
        doAnswer(inv -> {
            MigrationTestRun r = inv.getArgument(0);
            r.setId(50L);
            r.setCreatedAt(LocalDateTime.now());
            r.setUpdatedAt(LocalDateTime.now());
            return 1;
        }).when(testRunMapper).insert(any(MigrationTestRun.class));

        MigrationGenerateDTO.RunTestRequest req = new MigrationGenerateDTO.RunTestRequest();
        req.setProjectId(1L);

        MigrationGenerateDTO.TestRunResponse resp = generateService.runTests(req);

        assertThat(resp.getStatus()).isEqualTo(TestStatus.RUNNING);
        assertThat(resp.getArtifactId()).isEqualTo(40L);
        verify(projectService).updateStatus(1L, MigrationStatus.TESTING);
    }

    @Test
    @DisplayName("触发测试：指定 artifactId 时使用该 artifact")
    void runTests_withSpecificArtifactId_usesThatArtifact() {
        when(projectService.getById(1L)).thenReturn(sampleProject);
        when(artifactMapper.selectById(40L)).thenReturn(sampleArtifact);
        doAnswer(inv -> {
            MigrationTestRun r = inv.getArgument(0);
            r.setId(51L);
            r.setCreatedAt(LocalDateTime.now());
            r.setUpdatedAt(LocalDateTime.now());
            return 1;
        }).when(testRunMapper).insert(any(MigrationTestRun.class));

        MigrationGenerateDTO.RunTestRequest req = new MigrationGenerateDTO.RunTestRequest();
        req.setProjectId(1L);
        req.setArtifactId(40L);

        MigrationGenerateDTO.TestRunResponse resp = generateService.runTests(req);

        assertThat(resp.getArtifactId()).isEqualTo(40L);
        verify(artifactMapper, never()).selectActiveByProjectIdAndType(any(), any());
    }

    @Test
    @DisplayName("触发测试：无可用 XSLT 时抛出 404")
    void runTests_noActiveArtifact_throwsException() {
        when(projectService.getById(1L)).thenReturn(sampleProject);
        when(artifactMapper.selectActiveByProjectIdAndType(1L, ArtifactType.XSLT))
                .thenReturn(null);

        MigrationGenerateDTO.RunTestRequest req = new MigrationGenerateDTO.RunTestRequest();
        req.setProjectId(1L);

        assertThatThrownBy(() -> generateService.runTests(req))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    // ── getTestRunDetail ──────────────────────────────────────────────────────

    @Test
    @DisplayName("查询测试详情：包含 summary 和 cases 列表")
    void getTestRunDetail_returnsSummaryAndCases() {
        MigrationTestCaseResult caseResult = MigrationTestCaseResult.builder()
                .testRunId(50L)
                .exampleId(20L)
                .caseName("sample-01")
                .status(TestStatus.PASSED)
                .durationMs(120L)
                .build();
        caseResult.setId(60L);
        caseResult.setCreatedAt(LocalDateTime.now());

        when(testRunMapper.selectById(50L)).thenReturn(sampleRun);
        when(caseResultMapper.selectByTestRunId(50L)).thenReturn(List.of(caseResult));

        MigrationGenerateDTO.TestRunDetail detail = generateService.getTestRunDetail(50L);

        assertThat(detail.getSummary().getId()).isEqualTo(50L);
        assertThat(detail.getCases()).hasSize(1);
        assertThat(detail.getCases().get(0).getCaseName()).isEqualTo("sample-01");
        assertThat(detail.getCases().get(0).getStatus()).isEqualTo(TestStatus.PASSED);
    }

    @Test
    @DisplayName("查询测试详情：TestRun 不存在时抛出 404")
    void getTestRunDetail_notFound_throwsException() {
        when(testRunMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> generateService.getTestRunDetail(99L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }
}

