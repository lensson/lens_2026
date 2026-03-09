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
 * MigrationTestRunMapper 持久层单元测试
 *
 * 覆盖：insert / 按项目倒序查询 / 按状态过滤 / 最新一次执行 / 按产物 ID 查询
 */
@DisplayName("MigrationTestRunMapper - 测试执行记录管理")
class MigrationTestRunMapperTest extends BaseMapperTest {

    @Autowired private MigrationProjectMapper  projectMapper;
    @Autowired private MigrationArtifactMapper artifactMapper;
    @Autowired private MigrationTestRunMapper  testRunMapper;

    private Long projectId;
    private Long artifactId;
    private Long runId;
    private Long runId2;

    @Override
    protected void cleanTestData() {
        if (runId      != null) { testRunMapper.deleteById(runId);       runId      = null; }
        if (runId2     != null) { testRunMapper.deleteById(runId2);      runId2     = null; }
        if (artifactId != null) { artifactMapper.deleteById(artifactId); artifactId = null; }
        if (projectId  != null) { projectMapper.deleteById(projectId);   projectId  = null; }
    }

    private void createProjectAndArtifact() {
        MigrationProject p = MigrationProject.builder()
                .name("TestRun Project").deviceModel("run-device")
                .sourceVersion("26.2").targetVersion("26.3")
                .migrationType(MigrationType.INTENT_DRIVEN)
                .status(MigrationStatus.TESTING).createdBy("tester").build();
        projectMapper.insert(p);
        projectId = p.getId();

        MigrationArtifact artifact = MigrationArtifact.builder()
                .projectId(projectId).artifactType(ArtifactType.XSLT)
                .fileName("test.xslt").storagePath("/test.xslt").version(1).isActive(true).build();
        artifactMapper.insert(artifact);
        artifactId = artifact.getId();
    }

    @Test
    @DisplayName("insert：新建测试执行记录，统计字段默认为 0")
    void testInsert() {
        createProjectAndArtifact();

        MigrationTestRun run = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId)
                .status(TestStatus.RUNNING).build();
        int rows = testRunMapper.insert(run);
        runId = run.getId();

        assertThat(rows).isEqualTo(1);
        MigrationTestRun found = testRunMapper.selectById(runId);
        assertThat(found.getStatus()).isEqualTo(TestStatus.RUNNING);
        assertThat(found.getTotalCases()).isEqualTo(0);
        assertThat(found.getPassedCases()).isEqualTo(0);
    }

    @Test
    @DisplayName("updateById：更新测试完成后的统计结果")
    void testUpdateResult() {
        createProjectAndArtifact();

        MigrationTestRun run = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId)
                .status(TestStatus.RUNNING).build();
        testRunMapper.insert(run);
        runId = run.getId();

        run.setStatus(TestStatus.PASSED);
        run.setTotalCases(3);
        run.setPassedCases(3);
        run.setFailedCases(0);
        run.setDurationMs(1500L);
        testRunMapper.updateById(run);

        MigrationTestRun updated = testRunMapper.selectById(runId);
        assertThat(updated.getStatus()).isEqualTo(TestStatus.PASSED);
        assertThat(updated.getTotalCases()).isEqualTo(3);
        assertThat(updated.getPassedCases()).isEqualTo(3);
        assertThat(updated.getDurationMs()).isEqualTo(1500L);
    }

    @Test
    @DisplayName("selectByProjectIdDesc：倒序返回项目所有测试执行记录")
    void testSelectByProjectIdDesc() {
        createProjectAndArtifact();

        MigrationTestRun r1 = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId).status(TestStatus.FAILED).build();
        MigrationTestRun r2 = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId).status(TestStatus.PASSED).build();
        testRunMapper.insert(r1); runId  = r1.getId();
        testRunMapper.insert(r2); runId2 = r2.getId();

        List<MigrationTestRun> runs = testRunMapper.selectByProjectIdDesc(projectId);
        assertThat(runs).hasSize(2);
        // 最新插入（r2）应在前（id 更大）
        assertThat(runs.get(0).getId()).isGreaterThan(runs.get(1).getId());
    }

    @Test
    @DisplayName("selectByProjectIdAndStatus：按 PASSED 状态过滤")
    void testSelectByStatus() {
        createProjectAndArtifact();

        MigrationTestRun r1 = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId).status(TestStatus.FAILED).build();
        MigrationTestRun r2 = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId).status(TestStatus.PASSED).build();
        testRunMapper.insert(r1); runId  = r1.getId();
        testRunMapper.insert(r2); runId2 = r2.getId();

        List<MigrationTestRun> passed = testRunMapper.selectByProjectIdAndStatus(projectId, TestStatus.PASSED);
        assertThat(passed).hasSize(1);
        assertThat(passed.get(0).getStatus()).isEqualTo(TestStatus.PASSED);
    }

    @Test
    @DisplayName("selectLatestByProjectId：查询项目最新一次测试")
    void testSelectLatest() {
        createProjectAndArtifact();

        MigrationTestRun r1 = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId).status(TestStatus.FAILED).build();
        MigrationTestRun r2 = MigrationTestRun.builder()
                .projectId(projectId).artifactId(artifactId).status(TestStatus.PASSED).build();
        testRunMapper.insert(r1); runId  = r1.getId();
        testRunMapper.insert(r2); runId2 = r2.getId();

        MigrationTestRun latest = testRunMapper.selectLatestByProjectId(projectId);
        assertThat(latest.getId()).isEqualTo(runId2);
        assertThat(latest.getStatus()).isEqualTo(TestStatus.PASSED);
    }
}

