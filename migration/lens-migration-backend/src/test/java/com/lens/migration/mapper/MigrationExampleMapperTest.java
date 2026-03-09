package com.lens.migration.mapper;

import com.lens.migration.domain.MigrationExample;
import com.lens.migration.domain.MigrationProject;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.mapper.MigrationExampleMapper;
import com.lens.migration.mapper.MigrationProjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * MigrationExampleMapper 持久层单元测试
 *
 * 覆盖：insert / selectByProjectId / selectByProjectIdAndOperation
 */
@DisplayName("MigrationExampleMapper - XML 样本对 CRUD + 自定义查询")
class MigrationExampleMapperTest extends BaseMapperTest {

    @Autowired
    private MigrationProjectMapper projectMapper;

    @Autowired
    private MigrationExampleMapper exampleMapper;

    private Long projectId;
    private Long exampleId;
    private Long exampleId2;

    @Override
    protected void cleanTestData() {
        if (exampleId  != null) { exampleMapper.deleteById(exampleId);  exampleId  = null; }
        if (exampleId2 != null) { exampleMapper.deleteById(exampleId2); exampleId2 = null; }
        if (projectId  != null) { projectMapper.deleteById(projectId);  projectId  = null; }
    }

    private Long createProject() {
        MigrationProject p = MigrationProject.builder()
                .name("Example Test Project").deviceModel("example-device")
                .sourceVersion("26.2").targetVersion("26.3")
                .migrationType(MigrationType.INTENT_DRIVEN)
                .status(MigrationStatus.CREATED).createdBy("tester").build();
        projectMapper.insert(p);
        return p.getId();
    }

    private MigrationExample buildExample(Long projId, String sampleName, String opType) {
        return MigrationExample.builder()
                .projectId(projId)
                .sampleName(sampleName)
                .operationType(opType)
                .inputFileName("input-old.xml")
                .inputStoragePath("/xml/input/" + sampleName + "-old.xml")
                .expectedFileName("expected-new.xml")
                .expectedStoragePath("/xml/expected/" + sampleName + "-new.xml")
                .rootXpath("classifiers")
                .namespaceMap("{\"bbf\":\"urn:broadband-forum-org:yang:bbf-classifiers\"}")
                .build();
    }

    @Test
    @DisplayName("insert：插入 XML 样本对后 id 自动生成")
    void testInsert() {
        projectId = createProject();
        MigrationExample example = buildExample(projectId, "sample-classifier-01", "edit-config");
        int rows = exampleMapper.insert(example);
        exampleId = example.getId();

        assertThat(rows).isEqualTo(1);
        assertThat(example.getId()).isNotNull();
        assertThat(example.getCreatedAt()).isNotNull();
    }

    @Test
    @DisplayName("selectByProjectId：按项目 ID 查询所有样本对")
    void testSelectByProjectId() {
        projectId = createProject();

        MigrationExample e1 = buildExample(projectId, "sample-01", "edit-config");
        MigrationExample e2 = buildExample(projectId, "sample-02", "get-config");
        exampleMapper.insert(e1); exampleId  = e1.getId();
        exampleMapper.insert(e2); exampleId2 = e2.getId();

        List<MigrationExample> results = exampleMapper.selectByProjectId(projectId);
        assertThat(results).hasSize(2);
        assertThat(results).extracting(MigrationExample::getSampleName)
                .containsExactlyInAnyOrder("sample-01", "sample-02");
    }

    @Test
    @DisplayName("selectByProjectIdAndOperation：按操作类型（edit-config）过滤")
    void testSelectByOperation() {
        projectId = createProject();

        MigrationExample editExample = buildExample(projectId, "edit-sample", "edit-config");
        MigrationExample getExample  = buildExample(projectId, "get-sample",  "get-config");
        exampleMapper.insert(editExample); exampleId  = editExample.getId();
        exampleMapper.insert(getExample);  exampleId2 = getExample.getId();

        List<MigrationExample> editResults = exampleMapper.selectByProjectIdAndOperation(projectId, "edit-config");
        assertThat(editResults).hasSize(1);
        assertThat(editResults.get(0).getOperationType()).isEqualTo("edit-config");

        List<MigrationExample> getResults = exampleMapper.selectByProjectIdAndOperation(projectId, "get-config");
        assertThat(getResults).hasSize(1);
    }

    @Test
    @DisplayName("selectById：按 ID 查询数据完整性校验")
    void testSelectById() {
        projectId = createProject();
        MigrationExample example = buildExample(projectId, "integrity-check", "create");
        exampleMapper.insert(example);
        exampleId = example.getId();

        MigrationExample found = exampleMapper.selectById(exampleId);
        assertThat(found).isNotNull();
        assertThat(found.getSampleName()).isEqualTo("integrity-check");
        assertThat(found.getRootXpath()).isEqualTo("classifiers");
        assertThat(found.getNamespaceMap()).contains("bbf-classifiers");
    }
}

