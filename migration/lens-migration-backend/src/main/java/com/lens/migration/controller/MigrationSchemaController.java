package com.lens.migration.controller;

import com.lens.migration.common.ApiResponse;
import com.lens.migration.dto.MigrationSchemaDTO;
import com.lens.migration.service.MigrationSchemaService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Yang Schema REST API
 */
@RestController
@RequestMapping("/api/v1/projects/{projectId}/schemas")
@RequiredArgsConstructor
@Tag(name = "Yang Schemas", description = "Yang Schema 文件管理")
public class MigrationSchemaController {

    private final MigrationSchemaService schemaService;

    @PostMapping
    @Operation(summary = "添加 Yang Schema")
    public ResponseEntity<ApiResponse<MigrationSchemaDTO.Response>> add(
            @PathVariable Long projectId,
            @Valid @RequestBody MigrationSchemaDTO.CreateRequest req) {
        req.setProjectId(projectId);
        return ResponseEntity.status(201).body(ApiResponse.created(schemaService.add(req)));
    }

    @GetMapping
    @Operation(summary = "查询项目所有 Schema")
    public ResponseEntity<ApiResponse<List<MigrationSchemaDTO.Response>>> list(
            @PathVariable Long projectId,
            @RequestParam(required = false) String schemaVersion) {
        List<MigrationSchemaDTO.Response> list = (schemaVersion != null)
                ? schemaService.listByProjectAndVersion(projectId, schemaVersion)
                : schemaService.listByProject(projectId);
        return ResponseEntity.ok(ApiResponse.ok(list));
    }

    @GetMapping("/{id}")
    @Operation(summary = "查询 Schema 详情")
    public ResponseEntity<ApiResponse<MigrationSchemaDTO.Response>> getById(
            @PathVariable Long projectId, @PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(schemaService.getById(id)));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除 Schema")
    public ResponseEntity<ApiResponse<Void>> delete(
            @PathVariable Long projectId, @PathVariable Long id) {
        schemaService.delete(id);
        return ResponseEntity.ok(ApiResponse.ok("deleted", null));
    }
}

