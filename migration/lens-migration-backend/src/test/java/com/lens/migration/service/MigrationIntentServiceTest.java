package com.lens.migration.service;

import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.lens.migration.common.BusinessException;
import com.lens.migration.domain.MigrationIntent;
import com.lens.migration.dto.MigrationIntentDTO;
import com.lens.migration.mapper.MigrationIntentMapper;
import com.lens.migration.service.impl.MigrationIntentServiceImpl;
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
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("MigrationIntentService 单元测试")
class MigrationIntentServiceTest {

    @Mock
    private MigrationIntentMapper intentMapper;

    @InjectMocks
    private MigrationIntentServiceImpl intentService;

    private MigrationIntent sampleIntent;

    @BeforeEach
    void setUp() {
        sampleIntent = MigrationIntent.builder()
                .projectId(1L)
                .version(1)
                .fileName("intent-v1.md")
                .storagePath("/intent/1/v1/intent-v1.md")
                .content("## 迁移意图\n- 重命名 classifiers 节点")
                .isActive(true)
                .build();
        sampleIntent.setId(30L);
        sampleIntent.setCreatedAt(LocalDateTime.now());
        sampleIntent.setUpdatedAt(LocalDateTime.now());
    }

    // ── upload（首次上传，版本从1开始）─────────────────────────────────────────

    @Test
    @DisplayName("首次上传意图文档：版本为1，isActive=true")
    void upload_firstVersion_versionIsOne() {
        when(intentMapper.selectLatestByProjectId(1L)).thenReturn(null);
        when(intentMapper.update(isNull(), any(LambdaUpdateWrapper.class))).thenReturn(0);
        doAnswer(inv -> {
            MigrationIntent i = inv.getArgument(0);
            i.setId(30L);
            i.setCreatedAt(LocalDateTime.now());
            i.setUpdatedAt(LocalDateTime.now());
            return 1;
        }).when(intentMapper).insert(any(MigrationIntent.class));

        MigrationIntentDTO.CreateRequest req = new MigrationIntentDTO.CreateRequest();
        req.setProjectId(1L);
        req.setFileName("intent-v1.md");
        req.setContent("## 迁移意图\n- 重命名 classifiers 节点");

        MigrationIntentDTO.Response resp = intentService.upload(req);

        assertThat(resp.getVersion()).isEqualTo(1);
        assertThat(resp.getIsActive()).isTrue();
        assertThat(resp.getProjectId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("二次上传意图文档：版本自动递增为2")
    void upload_secondVersion_versionIncrements() {
        when(intentMapper.selectLatestByProjectId(1L)).thenReturn(sampleIntent); // v1 已存在
        when(intentMapper.update(isNull(), any(LambdaUpdateWrapper.class))).thenReturn(1);
        doAnswer(inv -> {
            MigrationIntent i = inv.getArgument(0);
            i.setId(31L);
            i.setCreatedAt(LocalDateTime.now());
            i.setUpdatedAt(LocalDateTime.now());
            return 1;
        }).when(intentMapper).insert(any(MigrationIntent.class));

        MigrationIntentDTO.CreateRequest req = new MigrationIntentDTO.CreateRequest();
        req.setProjectId(1L);
        req.setFileName("intent-v2.md");
        req.setContent("## 迁移意图 v2");

        MigrationIntentDTO.Response resp = intentService.upload(req);

        assertThat(resp.getVersion()).isEqualTo(2);
        assertThat(resp.getIsActive()).isTrue();
        // 应先将旧版本设为非激活
        verify(intentMapper).update(isNull(), any(LambdaUpdateWrapper.class));
    }

    // ── listByProject ─────────────────────────────────────────────────────────

    @Test
    @DisplayName("按项目查询：返回倒序版本列表")
    void listByProject_returnsList() {
        when(intentMapper.selectByProjectIdOrderByVersionDesc(1L))
                .thenReturn(List.of(sampleIntent));

        List<MigrationIntentDTO.Response> result = intentService.listByProject(1L);

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getFileName()).isEqualTo("intent-v1.md");
    }

    // ── getActive / getLatest ─────────────────────────────────────────────────

    @Test
    @DisplayName("getActive：有激活版本时正确返回")
    void getActive_found_returnsActiveIntent() {
        when(intentMapper.selectActiveByProjectId(1L)).thenReturn(sampleIntent);

        MigrationIntentDTO.Response resp = intentService.getActive(1L);

        assertThat(resp.getIsActive()).isTrue();
        assertThat(resp.getVersion()).isEqualTo(1);
    }

    @Test
    @DisplayName("getActive：无激活版本时抛出 404")
    void getActive_notFound_throwsException() {
        when(intentMapper.selectActiveByProjectId(1L)).thenReturn(null);

        assertThatThrownBy(() -> intentService.getActive(1L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    @Test
    @DisplayName("getLatest：无任何版本时抛出 404")
    void getLatest_notFound_throwsException() {
        when(intentMapper.selectLatestByProjectId(99L)).thenReturn(null);

        assertThatThrownBy(() -> intentService.getLatest(99L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    // ── activate ──────────────────────────────────────────────────────────────

    @Test
    @DisplayName("激活指定版本：取消其他版本后激活目标版本")
    void activate_shouldDeactivateOthersAndActivateTarget() {
        when(intentMapper.selectById(30L)).thenReturn(sampleIntent);
        when(intentMapper.update(isNull(), any(LambdaUpdateWrapper.class))).thenReturn(1);

        intentService.activate(30L);

        verify(intentMapper).updateById(argThat((MigrationIntent i) -> Boolean.TRUE.equals(i.getIsActive())));
    }

    @Test
    @DisplayName("激活不存在的版本：抛出 404")
    void activate_notFound_throwsException() {
        when(intentMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> intentService.activate(99L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    // ── delete ────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("删除意图文档：成功调用 deleteById")
    void delete_shouldCallDeleteById() {
        when(intentMapper.selectById(30L)).thenReturn(sampleIntent);

        intentService.delete(30L);

        verify(intentMapper).deleteById(30L);
    }
}

