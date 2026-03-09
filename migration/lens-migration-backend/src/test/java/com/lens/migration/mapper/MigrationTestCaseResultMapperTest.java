package com.lens.migration.mapper;

import com.lens.migration.domain.*;
import com.lens.migration.domain.enums.*;
import com.lens.migration.repository.*;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * MigrationTestCaseResultMapper 持久层单元测试
 *
 * 覆盖：insert / 批量插入用例结果 / 按 testRunId 查询 / 按状态过滤 / diff 内容保存
 */
@DisplayName("MigrationTestCaseResultMapper - 单条用例结果 CRUD")
class MigrationTestCaseResultMapperTest extends BaseMapperTest {

    @Autowired private MigrationProjectMapper         projectMapper;
    @Autowired private MigrationArtifactMapper        artifactMapper;
    @Autowired private MigrationExampleMapper         exampleMapper;
    @Autowired private MigrationTestRunMapper         testRunMapper;
    @Autowired private MigrationTestCaseResultMapper  caseResultMapper;

    private Long projectId;
    private Long artifactId;
    private Long exampleId;
    private Long exampleId2;
    private Long runId;
    private Long caseId;
    private Long caseId2;

    @Override
    protected void cleanTestData() {
        if (caseId    != null) { caseResultMapper.deleteById(caseId);   caseId    = null; }
        if (caseId2   != null) { caseResultMapper.deleteById(caseId2);  caseId2   = null; }
        if (runId     != null) { testRunMapper.deleteById(runId);        runId     = null; }
        if (exampleId != null) { exampleMapper.deleteById(exampleId);   exampleId = null; }
        if (exampleId2!= null) { exampleMapper.deleteById(exampleId2);  exampleId2= null; }
        if (artifactId!= null) { artifactMapper.deleteById(artifactId); artifactId= null; }
        if (projectId != null) { projectMapper.deleteById(projectId);   projectId = null; }
    }

    private void createFullChain() {
        MigrationProject p = MigrationProject.builder()
                .name("CaseResult Test").deviceModel("case-device")
                .sourceVersion("26.2").targetVersion("26.3")
                .migrationType(MigrationType.INTENT_DRIVEN)
                .status(MigrationStatus.TESTING).createdBy("tester").build();
        projectMapper.insert(p);
        projectId = p.getId();

        MigrationArtifact art = MigrationArtifact.builder()
                .projectId(projectId).artifactType(ArtifactType.XSLT)
                .fileName("t.xslt").storagePath("/t.xslt").version(1).isActive(true).build();
        artifactMapper.insert(art);
        artifactId = art.getId();

        MigrationExample ex1 = MigrationExample.builder()
                .projectId(projectId).sampleName("sample-pass").operationType("edit-config")
                .inputFileName("in-old.xml").inputStoragePath("/in-old.xml")
                .expectedFileName("out-new.xml").expectedStoragePath("/out-new.xml").build();
        MigrationExample ex2 = MigrationExample.builder()
                .projectId(projectId).sampleName("sample-fail").operationType("create")
                .inputFileName("in2-old.xml").inputStoragePath("/in2-old.xml")
                .expectedFileName("out2-new.xml").expectedStoragePath("/out2-new.xml").build();
        exampleMapper.insert(ex1); exampleId  = ex1.getId();
        exampleMapper.insert(ex2); exampleId2 = ex2.getId();

        MigrationTestRun run = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId).status(TestStatus.RUNNING).build();
        testRunMapper.insert(run);
        runId = run.getId();
    }

    @Test
    @DisplayName("insert：PASSED 用例结果存储完整")
    void testInsertPassed() {
        createFullChain();

        MigrationTestCaseResult result = MigrationTestCaseResult.builder()
                .testRunId(runId)
                .exampleId(exampleId)
                .caseName("sample-pass")
                .status(TestStatus.PASSED)
                .actualOutputPath("/output/sample-pass-actual.xml")
                .durationMs(120L)
                .build();
        int rows = caseResultMapper.insert(result);
        caseId = result.getId();

        assertThat(rows).isEqualTo(1);
        MigrationTestCaseResult found = caseResultMapper.selectById(caseId);
        assertThat(found.getStatus()).isEqualTo(TestStatus.PASSED);
        assertThat(found.getDurationMs()).isEqualTo(120L);
        assertThat(found.getDiffDetail()).isNull();
    }

    @Test
    @DisplayName("insert：FAILED 用例保存 diff 详情")
    void testInsertFailed() {
        createFullChain();

        String diff = "--- expected\n+++ actual\n@@ -1 +1 @@\n-<classifiers/>\n+<qos-classifiers/>";

        MigrationTestCaseResult result = MigrationTestCaseResult.builder()
                .testRunId(runId)
                .exampleId(exampleId2)
                .caseName("sample-fail")
                .status(TestStatus.FAILED)
                .actualOutputPath("/output/sample-fail-actual.xml")
                .diffDetail(diff)
                .durationMs(250L)
                .build();
        caseResultMapper.insert(result);
        caseId = result.getId();

        MigrationTestCaseResult found = caseResultMapper.selectById(caseId);
        assertThat(found.getStatus()).isEqualTo(TestStatus.FAILED);
        assertThat(found.getDiffDetail()).contains("classifiers");
        assertThat(found.getDiffDetail()).contains("qos-classifiers");
    }

    @Test
    @DisplayName("selectByTestRunId：按 testRunId 获取全部用例结果")
    void testSelectByTestRunId() {
        createFullChain();

        MigrationTestCaseResult r1 = MigrationTestCaseResult.builder()
                .testRunId(runId).exampleId(exampleId)
                .caseName("case1").status(TestStatus.PASSED).durationMs(100L).build();
        MigrationTestCaseResult r2 = MigrationTestCaseResult.builder()
                .testRunId(runId).exampleId(exampleId2)
                .caseName("case2").status(TestStatus.FAILED).durationMs(200L).build();
        caseResultMapper.insert(r1); caseId  = r1.getId();
        caseResultMapper.insert(r2); caseId2 = r2.getId();

        List<MigrationTestCaseResult> results = caseResultMapper.selectByTestRunId(runId);
        assertThat(results).hasSize(2);
        assertThat(results).extracting(MigrationTestCaseResult::getCaseName)
                .containsExactlyInAnyOrder("case1", "case2");
    }

    @Test
    @DisplayName("selectByTestRunIdAndStatus：只返回 FAILED 用例")
    void testSelectByStatus() {
        createFullChain();

        MigrationTestCaseResult passed = MigrationTestCaseResult.builder()
                .testRunId(runId).exampleId(exampleId)
                .caseName("case-pass").status(TestStatus.PASSED).build();
        MigrationTestCaseResult failed = MigrationTestCaseResult.builder()
                .testRunId(runId).exampleId(exampleId2)
                .caseName("case-fail").status(TestStatus.FAILED).diffDetail("diff content").build();
        caseResultMapper.insert(passed); caseId  = passed.getId();
        caseResultMapper.insert(failed); caseId2 = failed.getId();

        List<MigrationTestCaseResult> failedResults = caseResultMapper.selectByTestRunIdAndStatus(runId, TestStatus.FAILED);
        assertThat(failedResults).hasSize(1);
        assertThat(failedResults.get(0).getCaseName()).isEqualTo("case-fail");
        assertThat(failedResults.get(0).getDiffDetail()).isEqualTo("diff content");
    }
}

