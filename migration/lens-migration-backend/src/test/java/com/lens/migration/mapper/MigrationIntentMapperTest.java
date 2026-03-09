package com.lens.migration.mapper;

import com.lens.migration.domain.MigrationIntent;
import com.lens.migration.domain.MigrationProject;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.repository.MigrationIntentMapper;
import com.lens.migration.repository.MigrationProjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * MigrationIntentMapper 持久层单元测试
 *
 * 覆盖：insert / 多版本管理 / 查询激活版本 / 查询最新版本
 */
@DisplayName("MigrationIntentMapper - 意图文档多版本管理")
class MigrationIntentMapperTest extends BaseMapperTest {

    @Autowired
    private MigrationProjectMapper projectMapper;

    @Autowired
    private MigrationIntentMapper intentMapper;

    private Long projectId;
    private Long intentId;
    private Long intentId2;

    @Override
    protected void cleanTestData() {
        if (intentId  != null) { intentMapper.deleteById(intentId);  intentId  = null; }
        if (intentId2 != null) { intentMapper.deleteById(intentId2); intentId2 = null; }
        if (projectId != null) { projectMapper.deleteById(projectId); projectId = null; }
    }

    private Long createProject() {
        MigrationProject p = MigrationProject.builder()
                .name("Intent Test Project").deviceModel("intent-device")
                .sourceVersion("26.2").targetVersion("26.3")
                .migrationType(MigrationType.INTENT_DRIVEN)
                .status(MigrationStatus.CREATED).createdBy("tester").build();
        projectMapper.insert(p);
        return p.getId();
    }

    @Test
    @DisplayName("insert：插入意图文档，content 和 parsedRules 完整存储")
    void testInsert() {
        projectId = createProject();
        String md = "# 迁移意图\n## 规则\n1. 将 bbf:classifiers 重命名为 bbf:qos-classifiers";
        String rules = "[{\"type\":\"RENAME\",\"source_xpath\":\"bbf:classifiers\",\"target_xpath\":\"bbf:qos-classifiers\"}]";

        MigrationIntent intent = MigrationIntent.builder()
                .projectId(projectId)
                .version(1)
                .fileName("intent-v1.md")
                .storagePath("/intent/intent-v1.md")
                .content(md)
                .parsedRules(rules)
                .rulesCount(1)
                .isActive(true)
                .build();
        int rows = intentMapper.insert(intent);
        intentId = intent.getId();

        assertThat(rows).isEqualTo(1);
        MigrationIntent found = intentMapper.selectById(intentId);
        assertThat(found.getContent()).isEqualTo(md);
        assertThat(found.getParsedRules()).contains("RENAME");
        assertThat(found.getRulesCount()).isEqualTo(1);
    }

    @Test
    @DisplayName("selectByProjectIdOrderByVersionDesc：多版本倒序返回")
    void testSelectMultiVersionDesc() {
        projectId = createProject();

        MigrationIntent v1 = MigrationIntent.builder().projectId(projectId)
                .version(1).fileName("v1.md").storagePath("/v1.md")
                .content("v1 content").isActive(false).build();
        MigrationIntent v2 = MigrationIntent.builder().projectId(projectId)
                .version(2).fileName("v2.md").storagePath("/v2.md")
                .content("v2 content").isActive(true).build();
        intentMapper.insert(v1); intentId  = v1.getId();
        intentMapper.insert(v2); intentId2 = v2.getId();

        List<MigrationIntent> all = intentMapper.selectByProjectIdOrderByVersionDesc(projectId);
        assertThat(all).hasSize(2);
        // 倒序：版本 2 在前
        assertThat(all.get(0).getVersion()).isEqualTo(2);
        assertThat(all.get(1).getVersion()).isEqualTo(1);
    }

    @Test
    @DisplayName("selectActiveByProjectId：查询激活版本（is_active=1）")
    void testSelectActive() {
        projectId = createProject();

        MigrationIntent v1 = MigrationIntent.builder().projectId(projectId)
                .version(1).fileName("v1.md").storagePath("/v1.md")
                .content("v1").isActive(false).build();
        MigrationIntent v2 = MigrationIntent.builder().projectId(projectId)
                .version(2).fileName("v2.md").storagePath("/v2.md")
                .content("v2").isActive(true).build();
        intentMapper.insert(v1); intentId  = v1.getId();
        intentMapper.insert(v2); intentId2 = v2.getId();

        MigrationIntent active = intentMapper.selectActiveByProjectId(projectId);
        assertThat(active).isNotNull();
        assertThat(active.getIsActive()).isTrue();
        assertThat(active.getVersion()).isEqualTo(2);
    }

    @Test
    @DisplayName("selectLatestByProjectId：查询最新版本（version 最大）")
    void testSelectLatest() {
        projectId = createProject();

        MigrationIntent v1 = MigrationIntent.builder().projectId(projectId)
                .version(1).fileName("v1.md").storagePath("/v1.md").content("v1").isActive(false).build();
        MigrationIntent v3 = MigrationIntent.builder().projectId(projectId)
                .version(3).fileName("v3.md").storagePath("/v3.md").content("v3").isActive(true).build();
        intentMapper.insert(v1); intentId  = v1.getId();
        intentMapper.insert(v3); intentId2 = v3.getId();

        MigrationIntent latest = intentMapper.selectLatestByProjectId(projectId);
        assertThat(latest).isNotNull();
        assertThat(latest.getVersion()).isEqualTo(3);
    }
}

