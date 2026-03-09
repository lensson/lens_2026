package com.lens.migration.controller;

import com.lens.migration.common.ApiResponse;
import com.lens.migration.dto.MigrationGenerateDTO;
import com.lens.migration.service.MigrationGenerateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * XSLT 生成 & 测试执行 REST API
 */
@RestController
@RequestMapping("/api/v1/projects/{projectId}/generate")
@RequiredArgsConstructor
@Tag(name = "XSLT Generate & Test", description = "XSLT 生成与测试执行")
public class MigrationGenerateController {

    private final MigrationGenerateService generateService;

    // ── XSLT 生成 ────────────────────────────────────────────────────────────

    @PostMapping("/xslt")
    @Operation(summary = "触发 XSLT 生成")
    public ResponseEntity<ApiResponse<MigrationGenerateDTO.ArtifactResponse>> generateXslt(
            @PathVariable Long projectId,
            @Valid @RequestBody MigrationGenerateDTO.GenerateRequest req) {
        req.setProjectId(projectId);
        return ResponseEntity.status(202).body(
                ApiResponse.ok("XSLT generation started", generateService.generateXslt(req)));
    }

    @GetMapping("/xslt/active")
    @Operation(summary = "查询当前激活 XSLT 产物")
    public ResponseEntity<ApiResponse<MigrationGenerateDTO.ArtifactResponse>> getActiveXslt(
            @PathVariable Long projectId) {
        return ResponseEntity.ok(ApiResponse.ok(generateService.getActiveXslt(projectId)));
    }

    @GetMapping("/xslt/versions")
    @Operation(summary = "查询所有 XSLT 版本")
    public ResponseEntity<ApiResponse<List<MigrationGenerateDTO.ArtifactResponse>>> listXsltVersions(
            @PathVariable Long projectId) {
        return ResponseEntity.ok(ApiResponse.ok(generateService.listXsltVersions(projectId)));
    }

    @GetMapping("/artifacts/{artifactId}")
    @Operation(summary = "查询产物详情")
    public ResponseEntity<ApiResponse<MigrationGenerateDTO.ArtifactResponse>> getArtifact(
            @PathVariable Long projectId, @PathVariable Long artifactId) {
        return ResponseEntity.ok(ApiResponse.ok(generateService.getArtifactById(artifactId)));
    }

    // ── 测试执行 ─────────────────────────────────────────────────────────────

    @PostMapping("/tests/run")
    @Operation(summary = "触发测试执行")
    public ResponseEntity<ApiResponse<MigrationGenerateDTO.TestRunResponse>> runTests(
            @PathVariable Long projectId,
            @RequestBody(required = false) MigrationGenerateDTO.RunTestRequest req) {
        if (req == null) req = new MigrationGenerateDTO.RunTestRequest();
        req.setProjectId(projectId);
        return ResponseEntity.status(202).body(
                ApiResponse.ok("Test run started", generateService.runTests(req)));
    }

    @GetMapping("/tests/latest")
    @Operation(summary = "查询最新测试结果")
    public ResponseEntity<ApiResponse<MigrationGenerateDTO.TestRunResponse>> getLatestTestRun(
            @PathVariable Long projectId) {
        return ResponseEntity.ok(ApiResponse.ok(generateService.getLatestTestRun(projectId)));
    }

    @GetMapping("/tests")
    @Operation(summary = "查询所有测试批次")
    public ResponseEntity<ApiResponse<List<MigrationGenerateDTO.TestRunResponse>>> listTestRuns(
            @PathVariable Long projectId) {
        return ResponseEntity.ok(ApiResponse.ok(generateService.listTestRuns(projectId)));
    }

    @GetMapping("/tests/{testRunId}")
    @Operation(summary = "查询测试批次详情（含用例明细）")
    public ResponseEntity<ApiResponse<MigrationGenerateDTO.TestRunDetail>> getTestRunDetail(
            @PathVariable Long projectId, @PathVariable Long testRunId) {
        return ResponseEntity.ok(ApiResponse.ok(generateService.getTestRunDetail(testRunId)));
    }
}

