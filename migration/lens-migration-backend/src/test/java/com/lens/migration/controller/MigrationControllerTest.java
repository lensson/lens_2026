package com.lens.migration.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lens.migration.common.BusinessException;
import com.lens.migration.common.GlobalExceptionHandler;
import com.lens.migration.common.PageResult;
import com.lens.migration.domain.enums.AiProvider;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.dto.MigrationProjectDTO;
import com.lens.migration.mapper.MigrationArtifactMapper;
import com.lens.migration.mapper.MigrationExampleMapper;
import com.lens.migration.mapper.MigrationIntentMapper;
import com.lens.migration.mapper.MigrationProjectMapper;
import com.lens.migration.mapper.MigrationSchemaMapper;
import com.lens.migration.mapper.MigrationTestCaseResultMapper;
import com.lens.migration.mapper.MigrationTestRunMapper;
import com.lens.migration.service.MigrationProjectService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.time.LocalDateTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * MigrationController REST 层单元测试
 * 禁用 Security/DataSource/MyBatis 自动配置，只测试 HTTP 路由和 JSON 响应格式
 */
@WebMvcTest(
    controllers = MigrationController.class,
    excludeAutoConfiguration = {
        org.springframework.boot.autoconfigure.security.oauth2.resource.servlet.OAuth2ResourceServerAutoConfiguration.class,
        org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration.class,
        org.springframework.boot.autoconfigure.security.servlet.SecurityFilterAutoConfiguration.class,
        org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration.class,
        org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration.class,
        com.baomidou.mybatisplus.autoconfigure.MybatisPlusAutoConfiguration.class
    }
)
@AutoConfigureMockMvc(addFilters = false)
@Import(GlobalExceptionHandler.class)
@DisplayName("MigrationController REST 测试")
class MigrationControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;
    @MockBean MigrationProjectService projectService;
    // 防止 @MapperScan 注册真实 Mapper 导致 sqlSessionFactory 报错
    @MockBean MigrationProjectMapper migrationProjectMapper;
    @MockBean MigrationArtifactMapper migrationArtifactMapper;
    @MockBean MigrationExampleMapper migrationExampleMapper;
    @MockBean MigrationIntentMapper migrationIntentMapper;
    @MockBean MigrationSchemaMapper migrationSchemaMapper;
    @MockBean MigrationTestRunMapper migrationTestRunMapper;
    @MockBean MigrationTestCaseResultMapper migrationTestCaseResultMapper;

    private MigrationProjectDTO.Response buildResponse(Long id, String name) {
        MigrationProjectDTO.Response r = new MigrationProjectDTO.Response();
        r.setId(id);
        r.setName(name);
        r.setDeviceModel("ls-mf");
        r.setSourceVersion("26.2");
        r.setTargetVersion("26.3");
        r.setMigrationType(MigrationType.SCHEMA_DRIVEN);
        r.setStatus(MigrationStatus.CREATED);
        r.setAiProvider(AiProvider.GITHUB);
        r.setCreatedBy("test-user");
        r.setCreatedAt(LocalDateTime.now());
        r.setUpdatedAt(LocalDateTime.now());
        return r;
    }

    // ── POST /api/v1/projects ─────────────────────────────────────────────────

    @Test
    @DisplayName("POST /projects：创建成功返回 201 和项目信息")
    void createProject_success_returns201() throws Exception {
        MigrationProjectDTO.CreateRequest req = new MigrationProjectDTO.CreateRequest();
        req.setName("LWLT-C Test");
        req.setDeviceModel("ls-mf");
        req.setSourceVersion("26.2");
        req.setTargetVersion("26.3");
        req.setMigrationType(MigrationType.SCHEMA_DRIVEN);

        when(projectService.create(any(), anyString()))
                .thenReturn(buildResponse(1L, "LWLT-C Test"));

        mockMvc.perform(post("/api/v1/projects")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.name").value("LWLT-C Test"))
                .andExpect(jsonPath("$.data.status").value("CREATED"));
    }

    @Test
    @DisplayName("POST /projects：缺少必填字段返回 400")
    void createProject_missingField_returns400() throws Exception {
        MigrationProjectDTO.CreateRequest req = new MigrationProjectDTO.CreateRequest();
        req.setName("Test"); // 缺少 deviceModel, sourceVersion, targetVersion, migrationType

        mockMvc.perform(post("/api/v1/projects")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isBadRequest());
    }

    // ── GET /api/v1/projects/{id} ─────────────────────────────────────────────

    @Test
    @DisplayName("GET /projects/1：存在时返回 200 和项目信息")
    void getProject_found_returns200() throws Exception {
        when(projectService.getById(1L)).thenReturn(buildResponse(1L, "LWLT-C Test"));

        mockMvc.perform(get("/api/v1/projects/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.migrationType").value("SCHEMA_DRIVEN"));
    }

    @Test
    @DisplayName("GET /projects/99：不存在时返回 404")
    void getProject_notFound_returns404() throws Exception {
        when(projectService.getById(99L))
                .thenThrow(new BusinessException(404, "MigrationProject not found: id=99"));

        mockMvc.perform(get("/api/v1/projects/99"))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.code").value(404));
    }

    // ── GET /api/v1/projects ──────────────────────────────────────────────────

    @Test
    @DisplayName("GET /projects：分页查询返回 PageResult")
    void listProjects_returnsPageResult() throws Exception {
        MigrationProjectDTO.ListItem item = new MigrationProjectDTO.ListItem();
        item.setId(1L);
        item.setName("LWLT-C Test");
        item.setStatus(MigrationStatus.CREATED);

        PageResult<MigrationProjectDTO.ListItem> page =
                new PageResult<>(List.of(item), 1L, 0, 20);
        when(projectService.list(0, 20, null, null, null)).thenReturn(page);

        mockMvc.perform(get("/api/v1/projects?page=0&size=20"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.total").value(1))
                .andExpect(jsonPath("$.data.items[0].name").value("LWLT-C Test"));
    }

    // ── PUT /api/v1/projects/{id} ─────────────────────────────────────────────

    @Test
    @DisplayName("PUT /projects/1：更新成功返回 200")
    void updateProject_success_returns200() throws Exception {
        MigrationProjectDTO.UpdateRequest req = new MigrationProjectDTO.UpdateRequest();
        req.setName("新名称");

        when(projectService.update(eq(1L), any())).thenReturn(buildResponse(1L, "新名称"));

        mockMvc.perform(put("/api/v1/projects/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.name").value("新名称"));
    }

    // ── DELETE /api/v1/projects/{id} ──────────────────────────────────────────

    @Test
    @DisplayName("DELETE /projects/1：删除成功返回 200")
    void deleteProject_success_returns200() throws Exception {
        doNothing().when(projectService).delete(1L);

        mockMvc.perform(delete("/api/v1/projects/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(projectService).delete(1L);
    }
}
