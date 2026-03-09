package com.lens.migration.mapper;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lens.migration.domain.MigrationProject;
import com.lens.migration.domain.enums.AiProvider;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.mapper.MigrationProjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * MigrationProjectMapper 持久层单元测试
 *
 * 覆盖：insert / selectById / updateById / deleteById
 *       自定义查询：按状态、设备型号、创建人、迁移类型、关键字、版本范围
 */
@DisplayName("MigrationProjectMapper - 迁移项目 CRUD + 自定义查询")
class MigrationProjectMapperTest extends BaseMapperTest {

    @Autowired
    private MigrationProjectMapper projectMapper;

    // 记录插入的 ID，tearDown 时清理
    private Long insertedId;
    private Long insertedId2;

    @Override
    protected void cleanTestData() {
        if (insertedId != null)  { projectMapper.deleteById(insertedId);  insertedId  = null; }
        if (insertedId2 != null) { projectMapper.deleteById(insertedId2); insertedId2 = null; }
    }

    // -------------------------------------------------- helpers
    private MigrationProject buildProject(String name, String deviceModel, String sourceVer, String targetVer) {
        return MigrationProject.builder()
                .name(name)
                .deviceModel(deviceModel)
                .boardType("lwlt-c")
                .sourceVersion(sourceVer)
                .targetVersion(targetVer)
                .migrationType(MigrationType.INTENT_DRIVEN)
                .status(MigrationStatus.CREATED)
                .aiProvider(AiProvider.GITHUB)
                .createdBy("test-user")
                .build();
    }

    // -------------------------------------------------- 基础 CRUD
    @Test
    @DisplayName("insert：新建项目后 id 自动生成，createdAt/updatedAt 自动填充")
    void testInsert() {
        MigrationProject project = buildProject("LWLT-C 26.2→26.3", "ls-mf", "26.2", "26.3");
        int rows = projectMapper.insert(project);

        assertThat(rows).isEqualTo(1);
        assertThat(project.getId()).isNotNull().isPositive();
        assertThat(project.getCreatedAt()).isNotNull();
        assertThat(project.getUpdatedAt()).isNotNull();

        insertedId = project.getId();
    }

    @Test
    @DisplayName("selectById：插入后按 ID 查询到正确数据")
    void testSelectById() {
        MigrationProject project = buildProject("Test Select", "test-device", "1.0", "2.0");
        projectMapper.insert(project);
        insertedId = project.getId();

        MigrationProject found = projectMapper.selectById(insertedId);
        assertThat(found).isNotNull();
        assertThat(found.getName()).isEqualTo("Test Select");
        assertThat(found.getDeviceModel()).isEqualTo("test-device");
        assertThat(found.getMigrationType()).isEqualTo(MigrationType.INTENT_DRIVEN);
        assertThat(found.getStatus()).isEqualTo(MigrationStatus.CREATED);
    }

    @Test
    @DisplayName("updateById：更新 status 和 aiModel 后数据库反映变更")
    void testUpdateById() {
        MigrationProject project = buildProject("Update Test", "ls-mf", "26.2", "26.3");
        projectMapper.insert(project);
        insertedId = project.getId();

        project.setStatus(MigrationStatus.GENERATING);
        project.setAiModel("qwen2.5-coder:14b");
        project.setAiRoundsUsed(3);
        projectMapper.updateById(project);

        MigrationProject updated = projectMapper.selectById(insertedId);
        assertThat(updated.getStatus()).isEqualTo(MigrationStatus.GENERATING);
        assertThat(updated.getAiModel()).isEqualTo("qwen2.5-coder:14b");
        assertThat(updated.getAiRoundsUsed()).isEqualTo(3);
        assertThat(updated.getUpdatedAt()).isNotNull();
    }

    @Test
    @DisplayName("deleteById：删除后查询应返回 null")
    void testDeleteById() {
        MigrationProject project = buildProject("Delete Test", "ls-mf", "26.2", "26.3");
        projectMapper.insert(project);
        Long id = project.getId();

        projectMapper.deleteById(id);
        MigrationProject deleted = projectMapper.selectById(id);
        assertThat(deleted).isNull();
        // 已删除，不再需要 tearDown 清理
        insertedId = null;
    }

    // -------------------------------------------------- 自定义查询
    @Test
    @DisplayName("selectByStatus：按 CREATED 状态查询包含新插入项目")
    void testSelectByStatus() {
        MigrationProject project = buildProject("Status Query", "ls-mf", "26.2", "26.3");
        projectMapper.insert(project);
        insertedId = project.getId();

        List<MigrationProject> results = projectMapper.selectByStatus(MigrationStatus.CREATED);
        assertThat(results).isNotEmpty();
        assertThat(results).anyMatch(p -> p.getId().equals(insertedId));
    }

    @Test
    @DisplayName("selectByDeviceModel：按设备型号精确查询")
    void testSelectByDeviceModel() {
        MigrationProject project = buildProject("Device Query", "unique-test-device-xyz", "1.0", "2.0");
        projectMapper.insert(project);
        insertedId = project.getId();

        List<MigrationProject> results = projectMapper.selectByDeviceModel("unique-test-device-xyz");
        assertThat(results).hasSize(1);
        assertThat(results.get(0).getId()).isEqualTo(insertedId);
    }

    @Test
    @DisplayName("selectByCreatedBy：按创建人查询")
    void testSelectByCreatedBy() {
        MigrationProject project = buildProject("CreatedBy Query", "ls-mf", "26.2", "26.3");
        project.setCreatedBy("unique-tester-abc");
        projectMapper.insert(project);
        insertedId = project.getId();

        List<MigrationProject> results = projectMapper.selectByCreatedBy("unique-tester-abc");
        assertThat(results).isNotEmpty();
        assertThat(results).allMatch(p -> "unique-tester-abc".equals(p.getCreatedBy()));
    }

    @Test
    @DisplayName("searchByKeyword：关键字模糊搜索 name 字段")
    void testSearchByKeyword() {
        MigrationProject project = buildProject("VLAN Policy Migration Test XYZ", "ls-mf", "26.2", "26.3");
        projectMapper.insert(project);
        insertedId = project.getId();

        List<MigrationProject> results = projectMapper.searchByKeyword("XYZ");
        assertThat(results).isNotEmpty();
        assertThat(results).anyMatch(p -> p.getId().equals(insertedId));
    }

    @Test
    @DisplayName("selectByDeviceAndVersions：按设备+版本精确组合查询")
    void testSelectByDeviceAndVersions() {
        MigrationProject project = buildProject("Version Range Query", "version-device-xyz", "26.3", "26.4");
        projectMapper.insert(project);
        insertedId = project.getId();

        List<MigrationProject> results = projectMapper.selectByDeviceAndVersions("version-device-xyz", "26.3", "26.4");
        assertThat(results).hasSize(1);
        assertThat(results.get(0).getSourceVersion()).isEqualTo("26.3");
        assertThat(results.get(0).getTargetVersion()).isEqualTo("26.4");
    }

    @Test
    @DisplayName("LambdaQueryWrapper：使用 MP wrapper 组合条件查询")
    void testLambdaQueryWrapper() {
        MigrationProject p1 = buildProject("Wrapper Test SCHEMA", "wrapper-device", "1.0", "2.0");
        p1.setMigrationType(MigrationType.SCHEMA_DRIVEN);
        projectMapper.insert(p1);
        insertedId = p1.getId();

        MigrationProject p2 = buildProject("Wrapper Test HYBRID", "wrapper-device", "2.0", "3.0");
        p2.setMigrationType(MigrationType.HYBRID);
        projectMapper.insert(p2);
        insertedId2 = p2.getId();

        List<MigrationProject> results = projectMapper.selectList(
                new LambdaQueryWrapper<MigrationProject>()
                        .eq(MigrationProject::getDeviceModel, "wrapper-device")
                        .in(MigrationProject::getMigrationType, MigrationType.SCHEMA_DRIVEN, MigrationType.HYBRID)
        );
        assertThat(results).hasSize(2);
    }
}

