package com.lens.migration.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lens.migration.common.BusinessException;
import com.lens.migration.common.PageResult;
import com.lens.migration.domain.MigrationProject;
import com.lens.migration.domain.enums.AiProvider;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.dto.MigrationProjectDTO;
import com.lens.migration.mapper.MigrationProjectMapper;
import com.lens.migration.service.impl.MigrationProjectServiceImpl;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * MigrationProjectService 单元测试
 * 使用 Mockito 模拟 Mapper，不启动 Spring 容器
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("MigrationProjectService 单元测试")
class MigrationProjectServiceTest {

    @Mock
    private MigrationProjectMapper projectMapper;

    @InjectMocks
    private MigrationProjectServiceImpl projectService;

    private MigrationProject sampleProject;

    @BeforeEach
    void setUp() {
        sampleProject = MigrationProject.builder()
                .name("LWLT-C 26.2→26.3")
                .deviceModel("ls-mf")
                .boardType("lwlt-c")
                .sourceVersion("26.2")
                .targetVersion("26.3")
                .migrationType(MigrationType.SCHEMA_DRIVEN)
                .status(MigrationStatus.CREATED)
                .aiProvider(AiProvider.GITHUB)
                .createdBy("test-user")
                .build();
        sampleProject.setId(1L);
        sampleProject.setCreatedAt(LocalDateTime.now());
        sampleProject.setUpdatedAt(LocalDateTime.now());
    }

    // ── create ────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("创建项目：成功插入并返回 Response")
    void create_shouldInsertAndReturnResponse() {
        MigrationProjectDTO.CreateRequest req = new MigrationProjectDTO.CreateRequest();
        req.setName("LWLT-C 26.2→26.3");
        req.setDeviceModel("ls-mf");
        req.setBoardType("lwlt-c");
        req.setSourceVersion("26.2");
        req.setTargetVersion("26.3");
        req.setMigrationType(MigrationType.SCHEMA_DRIVEN);
        req.setAiProvider(AiProvider.GITHUB);

        // insert() 调用后设置 id（模拟数据库自增）
        doAnswer(inv -> {
            MigrationProject p = inv.getArgument(0);
            p.setId(1L);
            p.setCreatedAt(LocalDateTime.now());
            p.setUpdatedAt(LocalDateTime.now());
            return 1;
        }).when(projectMapper).insert(any(MigrationProject.class));

        MigrationProjectDTO.Response resp = projectService.create(req, "test-user");

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getName()).isEqualTo("LWLT-C 26.2→26.3");
        assertThat(resp.getStatus()).isEqualTo(MigrationStatus.CREATED);
        assertThat(resp.getCreatedBy()).isEqualTo("test-user");

        // 验证 insert 被调用一次
        ArgumentCaptor<MigrationProject> captor = ArgumentCaptor.forClass(MigrationProject.class);
        verify(projectMapper, times(1)).insert(captor.capture());
        assertThat(captor.getValue().getMigrationType()).isEqualTo(MigrationType.SCHEMA_DRIVEN);
    }

    // ── getById ───────────────────────────────────────────────────────────────

    @Test
    @DisplayName("按 ID 查询：存在时返回正确 Response")
    void getById_found_returnsResponse() {
        when(projectMapper.selectById(1L)).thenReturn(sampleProject);

        MigrationProjectDTO.Response resp = projectService.getById(1L);

        assertThat(resp.getId()).isEqualTo(1L);
        assertThat(resp.getDeviceModel()).isEqualTo("ls-mf");
    }

    @Test
    @DisplayName("按 ID 查询：不存在时抛出 BusinessException(404)")
    void getById_notFound_throwsException() {
        when(projectMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> projectService.getById(99L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("MigrationProject")
                .extracting("code").isEqualTo(404);
    }

    // ── list ──────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("分页查询：返回正确 PageResult")
    void list_returnsPageResult() {
        when(projectMapper.selectCount(any(LambdaQueryWrapper.class))).thenReturn(1L);
        when(projectMapper.selectList(any(LambdaQueryWrapper.class)))
                .thenReturn(List.of(sampleProject));

        PageResult<MigrationProjectDTO.ListItem> result =
                projectService.list(0, 10, null, null, null);

        assertThat(result.getTotal()).isEqualTo(1L);
        assertThat(result.getItems()).hasSize(1);
        assertThat(result.getItems().get(0).getName()).isEqualTo("LWLT-C 26.2→26.3");
        assertThat(result.getTotalPages()).isEqualTo(1);
    }

    @Test
    @DisplayName("分页查询：空结果时 items 为空列表")
    void list_empty_returnsEmptyPageResult() {
        when(projectMapper.selectCount(any(LambdaQueryWrapper.class))).thenReturn(0L);
        when(projectMapper.selectList(any(LambdaQueryWrapper.class))).thenReturn(List.of());

        PageResult<MigrationProjectDTO.ListItem> result =
                projectService.list(0, 10, MigrationStatus.COMPLETED, null, null);

        assertThat(result.getTotal()).isZero();
        assertThat(result.getItems()).isEmpty();
        assertThat(result.getTotalPages()).isZero();
    }

    // ── update ────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("更新项目：名称更新成功")
    void update_shouldUpdateName() {
        when(projectMapper.selectById(1L)).thenReturn(sampleProject);
        when(projectMapper.updateById(any(MigrationProject.class))).thenReturn(1);

        MigrationProjectDTO.UpdateRequest req = new MigrationProjectDTO.UpdateRequest();
        req.setName("新项目名");

        MigrationProjectDTO.Response resp = projectService.update(1L, req);

        assertThat(resp.getName()).isEqualTo("新项目名");
        verify(projectMapper).updateById(argThat((MigrationProject p) -> "新项目名".equals(p.getName())));
    }

    @Test
    @DisplayName("更新项目：项目不存在时抛出异常")
    void update_notFound_throwsException() {
        when(projectMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> projectService.update(99L, new MigrationProjectDTO.UpdateRequest()))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    // ── delete ────────────────────────────────────────────────────────────────

    @Test
    @DisplayName("删除项目：成功调用 deleteById")
    void delete_shouldCallDeleteById() {
        when(projectMapper.selectById(1L)).thenReturn(sampleProject);

        projectService.delete(1L);

        verify(projectMapper, times(1)).deleteById(1L);
    }

    @Test
    @DisplayName("删除项目：不存在时抛出异常")
    void delete_notFound_throwsException() {
        when(projectMapper.selectById(99L)).thenReturn(null);

        assertThatThrownBy(() -> projectService.delete(99L))
                .isInstanceOf(BusinessException.class)
                .extracting("code").isEqualTo(404);
    }

    // ── updateStatus ──────────────────────────────────────────────────────────

    @Test
    @DisplayName("更新状态：正确设置新状态并清除错误信息")
    void updateStatus_shouldSetStatusAndClearError() {
        sampleProject.setErrorMessage("旧错误");
        when(projectMapper.selectById(1L)).thenReturn(sampleProject);

        projectService.updateStatus(1L, MigrationStatus.GENERATING);

        verify(projectMapper).updateById(argThat((MigrationProject p) ->
                p.getStatus() == MigrationStatus.GENERATING && p.getErrorMessage() == null));
    }

    @Test
    @DisplayName("更新状态（含错误）：正确记录错误信息")
    void updateStatusWithError_shouldSetErrorMessage() {
        when(projectMapper.selectById(1L)).thenReturn(sampleProject);

        projectService.updateStatusWithError(1L, MigrationStatus.FAILED, "AI 调用超时");

        verify(projectMapper).updateById(argThat((MigrationProject p) ->
                p.getStatus() == MigrationStatus.FAILED
                        && "AI 调用超时".equals(p.getErrorMessage())));
    }
}

