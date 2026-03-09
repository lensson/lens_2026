package com.lens.migration.mapper;

import com.lens.migration.domain.MigrationProject;
import com.lens.migration.domain.MigrationSchema;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.mapper.MigrationProjectMapper;
import com.lens.migration.mapper.MigrationSchemaMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * MigrationSchemaMapper 持久层单元测试
 *
 * 覆盖：insert / selectByProjectId / source 和 target 版本分组 / Deviation 过滤 / checksum 去重
 */
@DisplayName("MigrationSchemaMapper - Yang Schema CRUD + 自定义查询")
class MigrationSchemaMapperTest extends BaseMapperTest {

    @Autowired
    private MigrationProjectMapper projectMapper;

    @Autowired
    private MigrationSchemaMapper schemaMapper;

    private Long projectId;
    private Long schemaId;
    private Long schemaId2;

    @Override
    protected void cleanTestData() {
        if (schemaId  != null) { schemaMapper.deleteById(schemaId);  schemaId  = null; }
        if (schemaId2 != null) { schemaMapper.deleteById(schemaId2); schemaId2 = null; }
        if (projectId != null) { projectMapper.deleteById(projectId); projectId = null; }
    }

    private Long createProject() {
        MigrationProject p = MigrationProject.builder()
                .name("Schema Test Project").deviceModel("schema-device")
                .sourceVersion("26.2").targetVersion("26.3")
                .migrationType(MigrationType.SCHEMA_DRIVEN)
                .status(MigrationStatus.CREATED)
                .createdBy("tester")
                .build();
        projectMapper.insert(p);
        return p.getId();
    }

    @Test
    @DisplayName("insert：插入 source Yang Schema，id 和时间自动生成")
    void testInsert() {
        projectId = createProject();
        MigrationSchema schema = MigrationSchema.builder()
                .projectId(projectId)
                .fileName("bbf-classifiers@26.2.yang")
                .moduleName("bbf-classifiers")
                .schemaVersion("source")
                .isDeviation(false)
                .storagePath("/yang/source/bbf-classifiers@26.2.yang")
                .fileSize(12345L)
                .checksum("abc123def456")
                .build();

        int rows = schemaMapper.insert(schema);
        schemaId = schema.getId();

        assertThat(rows).isEqualTo(1);
        assertThat(schema.getId()).isNotNull();
        assertThat(schema.getCreatedAt()).isNotNull();
    }

    @Test
    @DisplayName("selectByProjectId：按项目 ID 查询所有 Schema")
    void testSelectByProjectId() {
        projectId = createProject();

        MigrationSchema s1 = MigrationSchema.builder().projectId(projectId)
                .fileName("mod-a.yang").schemaVersion("source").isDeviation(false)
                .storagePath("/yang/source/mod-a.yang").build();
        MigrationSchema s2 = MigrationSchema.builder().projectId(projectId)
                .fileName("mod-a.yang").schemaVersion("target").isDeviation(false)
                .storagePath("/yang/target/mod-a.yang").build();
        schemaMapper.insert(s1); schemaId  = s1.getId();
        schemaMapper.insert(s2); schemaId2 = s2.getId();

        List<MigrationSchema> all = schemaMapper.selectByProjectId(projectId);
        assertThat(all).hasSize(2);
    }

    @Test
    @DisplayName("selectByProjectIdAndVersion：按版本（source/target）过滤")
    void testSelectByVersion() {
        projectId = createProject();

        MigrationSchema src = MigrationSchema.builder().projectId(projectId)
                .fileName("mod.yang").schemaVersion("source").isDeviation(false)
                .storagePath("/yang/source/mod.yang").build();
        MigrationSchema tgt = MigrationSchema.builder().projectId(projectId)
                .fileName("mod.yang").schemaVersion("target").isDeviation(false)
                .storagePath("/yang/target/mod.yang").build();
        schemaMapper.insert(src); schemaId  = src.getId();
        schemaMapper.insert(tgt); schemaId2 = tgt.getId();

        List<MigrationSchema> sourceSchemas = schemaMapper.selectByProjectIdAndVersion(projectId, "source");
        assertThat(sourceSchemas).hasSize(1);
        assertThat(sourceSchemas.get(0).getSchemaVersion()).isEqualTo("source");

        List<MigrationSchema> targetSchemas = schemaMapper.selectByProjectIdAndVersion(projectId, "target");
        assertThat(targetSchemas).hasSize(1);
    }

    @Test
    @DisplayName("selectByProjectIdAndDeviation：按 isDeviation 过滤 Deviation Yang")
    void testSelectByDeviation() {
        projectId = createProject();

        MigrationSchema mainYang = MigrationSchema.builder().projectId(projectId)
                .fileName("main.yang").schemaVersion("source").isDeviation(false)
                .storagePath("/yang/source/main.yang").build();
        MigrationSchema deviationYang = MigrationSchema.builder().projectId(projectId)
                .fileName("deviation.yang").schemaVersion("source").isDeviation(true)
                .storagePath("/yang/source/deviation.yang").build();
        schemaMapper.insert(mainYang);      schemaId  = mainYang.getId();
        schemaMapper.insert(deviationYang); schemaId2 = deviationYang.getId();

        List<MigrationSchema> deviations = schemaMapper.selectByProjectIdAndDeviation(projectId, true);
        assertThat(deviations).hasSize(1);
        assertThat(deviations.get(0).getIsDeviation()).isTrue();
    }

    @Test
    @DisplayName("selectByProjectIdAndChecksum：相同 checksum 防止重复上传")
    void testSelectByChecksum() {
        projectId = createProject();
        String checksum = "uniquechecksum1234567890";

        MigrationSchema schema = MigrationSchema.builder().projectId(projectId)
                .fileName("unique.yang").schemaVersion("source").isDeviation(false)
                .storagePath("/yang/source/unique.yang").checksum(checksum).build();
        schemaMapper.insert(schema);
        schemaId = schema.getId();

        MigrationSchema found = schemaMapper.selectByProjectIdAndChecksum(projectId, checksum);
        assertThat(found).isNotNull();
        assertThat(found.getChecksum()).isEqualTo(checksum);

        MigrationSchema notFound = schemaMapper.selectByProjectIdAndChecksum(projectId, "nonexistent");
        assertThat(notFound).isNull();
    }
}

