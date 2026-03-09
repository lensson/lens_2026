package com.lens.migration.controller;

import com.lens.migration.common.ApiResponse;
import com.lens.migration.dto.MigrationExampleDTO;
import com.lens.migration.service.MigrationExampleService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * XML 样本对 REST API
 */
@RestController
@RequestMapping("/api/v1/projects/{projectId}/examples")
@RequiredArgsConstructor
@Tag(name = "XML Examples", description = "XML 输入/输出样本对管理")
public class MigrationExampleController {

    private final MigrationExampleService exampleService;

    @PostMapping
    @Operation(summary = "添加 XML 样本对")
    public ResponseEntity<ApiResponse<MigrationExampleDTO.Response>> add(
            @PathVariable Long projectId,
            @Valid @RequestBody MigrationExampleDTO.CreateRequest req) {
        req.setProjectId(projectId);
        return ResponseEntity.status(201).body(ApiResponse.created(exampleService.add(req)));
    }

    @GetMapping
    @Operation(summary = "查询项目所有样本对")
    public ResponseEntity<ApiResponse<List<MigrationExampleDTO.Response>>> list(
            @PathVariable Long projectId,
            @RequestParam(required = false) String operationType) {
        List<MigrationExampleDTO.Response> list = (operationType != null)
                ? exampleService.listByProjectAndOperation(projectId, operationType)
                : exampleService.listByProject(projectId);
        return ResponseEntity.ok(ApiResponse.ok(list));
    }

    @GetMapping("/{id}")
    @Operation(summary = "查询样本对详情")
    public ResponseEntity<ApiResponse<MigrationExampleDTO.Response>> getById(
            @PathVariable Long projectId, @PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(exampleService.getById(id)));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除样本对")
    public ResponseEntity<ApiResponse<Void>> delete(
            @PathVariable Long projectId, @PathVariable Long id) {
        exampleService.delete(id);
        return ResponseEntity.ok(ApiResponse.ok("deleted", null));
    }
}

