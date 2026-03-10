package com.lens.migration.controller;

import com.lens.migration.common.ApiResponse;
import com.lens.migration.common.PageResult;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.dto.MigrationProjectDTO;
import com.lens.migration.service.MigrationProjectService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

/**
 * 迁移项目 REST API
 */
@RestController
@RequestMapping("/api/v1/projects")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Migration Projects", description = "迁移项目管理")
public class MigrationController {

    private final MigrationProjectService projectService;

    @PostMapping
    @Operation(summary = "创建迁移项目")
    public ResponseEntity<ApiResponse<MigrationProjectDTO.Response>> create(
            @Valid @RequestBody MigrationProjectDTO.CreateRequest req) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String createdBy = (auth != null && auth.isAuthenticated()) ? auth.getName() : "anonymous";
        MigrationProjectDTO.Response resp = projectService.create(req, createdBy);
        return ResponseEntity.status(201).body(ApiResponse.created(resp));
    }

    @GetMapping("/{id}")
    @Operation(summary = "查询迁移项目详情")
    public ResponseEntity<ApiResponse<MigrationProjectDTO.Response>> getById(@PathVariable Long id) {
        return ResponseEntity.ok(ApiResponse.ok(projectService.getById(id)));
    }

    @GetMapping
    @Operation(summary = "分页查询迁移项目列表")
    public ResponseEntity<ApiResponse<PageResult<MigrationProjectDTO.ListItem>>> list(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) MigrationStatus status,
            @RequestParam(required = false) MigrationType migrationType,
            @RequestParam(required = false) String keyword) {
        return ResponseEntity.ok(ApiResponse.ok(
                projectService.list(page, size, status, migrationType, keyword)));
    }

    @PutMapping("/{id}")
    @Operation(summary = "更新迁移项目")
    public ResponseEntity<ApiResponse<MigrationProjectDTO.Response>> update(
            @PathVariable Long id,
            @RequestBody MigrationProjectDTO.UpdateRequest req) {
        return ResponseEntity.ok(ApiResponse.ok(projectService.update(id, req)));
    }

    @DeleteMapping("/{id}")
    @Operation(summary = "删除迁移项目")
    public ResponseEntity<ApiResponse<Void>> delete(@PathVariable Long id) {
        projectService.delete(id);
        return ResponseEntity.ok(ApiResponse.ok("deleted", null));
    }
}
