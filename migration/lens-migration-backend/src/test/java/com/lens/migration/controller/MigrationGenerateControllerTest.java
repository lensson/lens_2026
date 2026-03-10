package com.lens.migration.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.lens.migration.common.BusinessException;
import com.lens.migration.common.GlobalExceptionHandler;
import com.lens.migration.domain.enums.ArtifactType;
import com.lens.migration.domain.enums.TestStatus;
import com.lens.migration.dto.MigrationGenerateDTO;
import com.lens.migration.mapper.MigrationArtifactMapper;
import com.lens.migration.mapper.MigrationExampleMapper;
import com.lens.migration.mapper.MigrationIntentMapper;
import com.lens.migration.mapper.MigrationProjectMapper;
import com.lens.migration.mapper.MigrationSchemaMapper;
import com.lens.migration.mapper.MigrationTestCaseResultMapper;
import com.lens.migration.mapper.MigrationTestRunMapper;
import com.lens.migration.service.MigrationGenerateService;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.jdbc.DataSourceTransactionManagerAutoConfiguration;
import org.springframework.boot.autoconfigure.security.oauth2.resource.servlet.OAuth2ResourceServerAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityFilterAutoConfiguration;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * MigrationGenerateController REST 层单元测试
 * 禁用 Security 自动配置，只测试 HTTP 路由和 JSON 响应格式
 */
@WebMvcTest(
    controllers = MigrationGenerateController.class,
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
@DisplayName("MigrationGenerateController REST 测试")
class MigrationGenerateControllerTest {

    @Autowired MockMvc mockMvc;
    @Autowired ObjectMapper objectMapper;
    @MockBean MigrationGenerateService generateService;
    // 防止 @MapperScan 注册真实 Mapper 导致 sqlSessionFactory 报错
    @MockBean MigrationProjectMapper migrationProjectMapper;
    @MockBean MigrationArtifactMapper migrationArtifactMapper;
    @MockBean MigrationExampleMapper migrationExampleMapper;
    @MockBean MigrationIntentMapper migrationIntentMapper;
    @MockBean MigrationSchemaMapper migrationSchemaMapper;
    @MockBean MigrationTestRunMapper migrationTestRunMapper;
    @MockBean MigrationTestCaseResultMapper migrationTestCaseResultMapper;

    private MigrationGenerateDTO.ArtifactResponse buildArtifact(Long id, int version) {
        MigrationGenerateDTO.ArtifactResponse r = new MigrationGenerateDTO.ArtifactResponse();
        r.setId(id);
        r.setProjectId(1L);
        r.setArtifactType(ArtifactType.XSLT);
        r.setFileName("generated-transform-v" + version + ".xslt");
        r.setVersion(version);
        r.setIsActive(true);
        r.setCreatedAt(LocalDateTime.now());
        return r;
    }

    private MigrationGenerateDTO.TestRunResponse buildTestRun(Long id, TestStatus status) {
        MigrationGenerateDTO.TestRunResponse r = new MigrationGenerateDTO.TestRunResponse();
        r.setId(id);
        r.setProjectId(1L);
        r.setArtifactId(40L);
        r.setStatus(status);
        r.setTotalCases(2);
        r.setPassedCases(2);
        r.setFailedCases(0);
        r.setCreatedAt(LocalDateTime.now());
        r.setUpdatedAt(LocalDateTime.now());
        return r;
    }

    // ── POST /generate/xslt ───────────────────────────────────────────────────

    @Test
    @DisplayName("POST /generate/xslt：触发生成返回 202 和 artifact 信息")
    void generateXslt_returns202() throws Exception {
        when(generateService.generateXslt(any())).thenReturn(buildArtifact(40L, 1));

        MigrationGenerateDTO.GenerateRequest req = new MigrationGenerateDTO.GenerateRequest();
        req.setProjectId(1L);

        mockMvc.perform(post("/api/v1/projects/1/generate/xslt")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isAccepted())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.version").value(1))
                .andExpect(jsonPath("$.data.artifactType").value("XSLT"));
    }

    @Test
    @DisplayName("POST /generate/xslt：项目不存在时返回 404")
    void generateXslt_projectNotFound_returns404() throws Exception {
        when(generateService.generateXslt(any()))
                .thenThrow(new BusinessException(404, "MigrationProject not found: id=99"));

        MigrationGenerateDTO.GenerateRequest req = new MigrationGenerateDTO.GenerateRequest();
        req.setProjectId(99L);

        mockMvc.perform(post("/api/v1/projects/99/generate/xslt")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    // ── GET /generate/xslt/active ─────────────────────────────────────────────

    @Test
    @DisplayName("GET /generate/xslt/active：返回激活产物")
    void getActiveXslt_returns200() throws Exception {
        when(generateService.getActiveXslt(1L)).thenReturn(buildArtifact(40L, 1));

        mockMvc.perform(get("/api/v1/projects/1/generate/xslt/active"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.isActive").value(true))
                .andExpect(jsonPath("$.data.version").value(1));
    }

    @Test
    @DisplayName("GET /generate/xslt/active：无产物时返回 404")
    void getActiveXslt_notFound_returns404() throws Exception {
        when(generateService.getActiveXslt(1L))
                .thenThrow(new BusinessException(404, "无激活 XSLT"));

        mockMvc.perform(get("/api/v1/projects/1/generate/xslt/active"))
                .andExpect(status().isNotFound());
    }

    // ── GET /generate/xslt/versions ───────────────────────────────────────────

    @Test
    @DisplayName("GET /generate/xslt/versions：返回版本列表")
    void listXsltVersions_returnsList() throws Exception {
        when(generateService.listXsltVersions(1L))
                .thenReturn(List.of(buildArtifact(40L, 1), buildArtifact(41L, 2)));

        mockMvc.perform(get("/api/v1/projects/1/generate/xslt/versions"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data.length()").value(2));
    }

    // ── POST /generate/tests/run ──────────────────────────────────────────────

    @Test
    @DisplayName("POST /generate/tests/run：触发测试返回 202 和 TestRun")
    void runTests_returns202() throws Exception {
        when(generateService.runTests(any())).thenReturn(buildTestRun(50L, TestStatus.RUNNING));

        mockMvc.perform(post("/api/v1/projects/1/generate/tests/run")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isAccepted())
                .andExpect(jsonPath("$.data.status").value("RUNNING"))
                .andExpect(jsonPath("$.data.projectId").value(1));
    }

    @Test
    @DisplayName("POST /generate/tests/run：无 XSLT 产物时返回 404")
    void runTests_noArtifact_returns404() throws Exception {
        when(generateService.runTests(any()))
                .thenThrow(new BusinessException(404, "无可用 XSLT 产物"));

        mockMvc.perform(post("/api/v1/projects/1/generate/tests/run")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isNotFound());
    }

    // ── GET /generate/tests/latest ────────────────────────────────────────────

    @Test
    @DisplayName("GET /generate/tests/latest：返回最新测试批次")
    void getLatestTestRun_returns200() throws Exception {
        when(generateService.getLatestTestRun(1L)).thenReturn(buildTestRun(50L, TestStatus.PASSED));

        mockMvc.perform(get("/api/v1/projects/1/generate/tests/latest"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.status").value("PASSED"))
                .andExpect(jsonPath("$.data.passedCases").value(2));
    }

    // ── GET /generate/tests/{testRunId} ───────────────────────────────────────

    @Test
    @DisplayName("GET /generate/tests/50：返回包含用例明细的 TestRunDetail")
    void getTestRunDetail_returns200WithCases() throws Exception {
        MigrationGenerateDTO.CaseResultResponse caseResp = new MigrationGenerateDTO.CaseResultResponse();
        caseResp.setId(60L);
        caseResp.setTestRunId(50L);
        caseResp.setCaseName("sample-01");
        caseResp.setStatus(TestStatus.PASSED);

        MigrationGenerateDTO.TestRunDetail detail = new MigrationGenerateDTO.TestRunDetail();
        detail.setSummary(buildTestRun(50L, TestStatus.PASSED));
        detail.setCases(List.of(caseResp));

        when(generateService.getTestRunDetail(50L)).thenReturn(detail);

        mockMvc.perform(get("/api/v1/projects/1/generate/tests/50"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.summary.id").value(50))
                .andExpect(jsonPath("$.data.cases.length()").value(1))
                .andExpect(jsonPath("$.data.cases[0].caseName").value("sample-01"));
    }
}

