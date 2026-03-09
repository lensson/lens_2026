package com.lens.migration.controller;

import com.lens.migration.common.ApiResponse;
import com.lens.migration.dto.MigrationIntentDTO;
import com.lens.migration.service.MigrationIntentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 迁移意图文档 REST API
 */
@RestController
@RequestMapping("/api/v1/projects/{projectId}/intents")
@RequiredArgsConstructor
@Tag(name = "Migration Intents", description = "迁移意图文档管理")
public class MigrationIntentController {

    private final MigrationIntentService intentService;

    @PostMapping
    @Operation(summary = "上传意图文档（自动递增版本）")
    public ResponseEntity<ApiResponse<MigrationIntentDTO.Response>> upload(
            @PathVariable Long projectId,
            @Valid @RequestBody MigrationIntentDTO.CreateRequest req) {
        req.setProjectId(projectId);
        return ResponseEntity.status(201).body(ApiResponse.created(intentService.upload(req)));
    }

    @GetMapping
    @Operation(summary = "查询项目所有意图文档版本")
    public ResponseEntity<ApiResponse<List<MigrationIntentDTO.Response>>> list(
            @PathVariable Long projectId) {
        return ResponseEntity.ok(ApiResponse.ok(intentService.listByProject(projectId)));
    }

    @GetMapping("/active")
    @Operation(summary = "查询当前激活意图文档")
    public ResponseEntity<ApiResponse<MigrationIntentDTO.Response>> getActive(
            @PathVariable Long projectId) {
        return ResponseEntity.ok(ApiResponse.ok(intentService.getActive(projectId)));
    }

    @GetMapping("/latest")
    @Operation(summary = "查询最新版本意图文档")
    public ResponseEntity<ApiResponse<MigrationIntentDTO.Response>> getLatest(
            @PathVariable Long projectId) {
        return ResponseEntity.ok(ApiResponse.ok(intentService.getLatest(projectId)));
    }

    @GetMapping("/{id}")
    @Operation(summary = "查询意图文档详情")
    public ResponseEntity<ApiResponse<MigrationIntentDTO.Response>> getById(
            @PathVariable Long projectId, @PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(intentService.getById(id)));
    }

    @PutMapping("/{id}/activate")
    @Operation(summary = "激活指定版本意图文档")
    public ResponseEntity<ApiResponse<Void>> activate(
            @PathVariable Long projectId, @PathVariable Long id) {
        intentService.activate(id);
        return ResponseEntity.ok(ApiResponse.ok("activated", null));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除意图文档版本")
    public ResponseEntity<ApiResponse<Void>> delete(
            @PathVariable Long projectId, @PathVariable Long id) {
        intentService.delete(id);
        return ResponseEntity.ok(ApiResponse.ok("deleted", null));
    }
}

