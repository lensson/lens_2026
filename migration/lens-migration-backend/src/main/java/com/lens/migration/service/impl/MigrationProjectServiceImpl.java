package com.lens.migration.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.lens.migration.common.BusinessException;
import com.lens.migration.common.PageResult;
import com.lens.migration.domain.MigrationProject;
import com.lens.migration.domain.enums.MigrationStatus;
import com.lens.migration.domain.enums.MigrationType;
import com.lens.migration.dto.MigrationProjectDTO;
import com.lens.migration.mapper.MigrationProjectMapper;
import com.lens.migration.service.MigrationProjectService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class MigrationProjectServiceImpl implements MigrationProjectService {

    private final MigrationProjectMapper projectMapper;

    @Override
    @Transactional
    public MigrationProjectDTO.Response create(MigrationProjectDTO.CreateRequest req, String createdBy) {
        MigrationProject project = MigrationProject.builder()
                .name(req.getName())
                .description(req.getDescription())
                .deviceModel(req.getDeviceModel())
                .boardType(req.getBoardType())
                .sourceVersion(req.getSourceVersion())
                .targetVersion(req.getTargetVersion())
                .migrationType(req.getMigrationType())
                .aiProvider(req.getAiProvider())
                .aiModel(req.getAiModel())
                .status(MigrationStatus.CREATED)
                .createdBy(createdBy)
                .build();
        projectMapper.insert(project);
        log.info("迁移项目已创建: id={}, name={}", project.getId(), project.getName());
        return toResponse(project);
    }

    @Override
    public MigrationProjectDTO.Response getById(Long id) {
        MigrationProject project = requireProject(id);
        return toResponse(project);
    }

    @Override
    public PageResult<MigrationProjectDTO.ListItem> list(int page, int size,
                                                          MigrationStatus status,
                                                          MigrationType migrationType,
                                                          String keyword) {
        LambdaQueryWrapper<MigrationProject> wrapper = new LambdaQueryWrapper<MigrationProject>()
                .eq(status != null, MigrationProject::getStatus, status)
                .eq(migrationType != null, MigrationProject::getMigrationType, migrationType)
                .and(StringUtils.hasText(keyword), w -> w
                        .like(MigrationProject::getName, keyword)
                        .or().like(MigrationProject::getDeviceModel, keyword))
                .orderByDesc(MigrationProject::getCreatedAt);

        long total = projectMapper.selectCount(wrapper);

        int offset = page * size;
        List<MigrationProject> records = projectMapper.selectList(
                wrapper.last("LIMIT " + size + " OFFSET " + offset));

        List<MigrationProjectDTO.ListItem> items = records.stream()
                .map(this::toListItem).toList();
        return new PageResult<>(items, total, page, size);
    }

    @Override
    @Transactional
    public MigrationProjectDTO.Response update(Long id, MigrationProjectDTO.UpdateRequest req) {
        MigrationProject project = requireProject(id);
        if (StringUtils.hasText(req.getName()))        project.setName(req.getName());
        if (StringUtils.hasText(req.getDescription())) project.setDescription(req.getDescription());
        if (req.getAiProvider() != null)               project.setAiProvider(req.getAiProvider());
        if (StringUtils.hasText(req.getAiModel()))     project.setAiModel(req.getAiModel());
        if (req.getStatus() != null)                   project.setStatus(req.getStatus());
        if (StringUtils.hasText(req.getErrorMessage())) project.setErrorMessage(req.getErrorMessage());
        projectMapper.updateById(project);
        return toResponse(project);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        requireProject(id);
        projectMapper.deleteById(id);
        log.info("迁移项目已删除: id={}", id);
    }

    @Override
    @Transactional
    public void updateStatus(Long id, MigrationStatus status) {
        MigrationProject project = requireProject(id);
        project.setStatus(status);
        project.setErrorMessage(null);
        projectMapper.updateById(project);
        log.info("项目状态更新: id={}, status={}", id, status);
    }

    @Override
    @Transactional
    public void updateStatusWithError(Long id, MigrationStatus status, String errorMessage) {
        MigrationProject project = requireProject(id);
        project.setStatus(status);
        project.setErrorMessage(errorMessage);
        projectMapper.updateById(project);
        log.warn("项目状态更新(含错误): id={}, status={}, error={}", id, status, errorMessage);
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private MigrationProject requireProject(Long id) {
        MigrationProject p = projectMapper.selectById(id);
        if (p == null) throw BusinessException.notFound("MigrationProject", id);
        return p;
    }

    private MigrationProjectDTO.Response toResponse(MigrationProject p) {
        MigrationProjectDTO.Response r = new MigrationProjectDTO.Response();
        r.setId(p.getId());
        r.setName(p.getName());
        r.setDescription(p.getDescription());
        r.setDeviceModel(p.getDeviceModel());
        r.setBoardType(p.getBoardType());
        r.setSourceVersion(p.getSourceVersion());
        r.setTargetVersion(p.getTargetVersion());
        r.setMigrationType(p.getMigrationType());
        r.setStatus(p.getStatus());
        r.setAiProvider(p.getAiProvider());
        r.setAiModel(p.getAiModel());
        r.setAiRoundsUsed(p.getAiRoundsUsed());
        r.setCreatedBy(p.getCreatedBy());
        r.setErrorMessage(p.getErrorMessage());
        r.setCreatedAt(p.getCreatedAt());
        r.setUpdatedAt(p.getUpdatedAt());
        return r;
    }

    private MigrationProjectDTO.ListItem toListItem(MigrationProject p) {
        MigrationProjectDTO.ListItem item = new MigrationProjectDTO.ListItem();
        item.setId(p.getId());
        item.setName(p.getName());
        item.setDeviceModel(p.getDeviceModel());
        item.setSourceVersion(p.getSourceVersion());
        item.setTargetVersion(p.getTargetVersion());
        item.setMigrationType(p.getMigrationType());
        item.setStatus(p.getStatus());
        item.setAiProvider(p.getAiProvider());
        item.setCreatedBy(p.getCreatedBy());
        item.setCreatedAt(p.getCreatedAt());
        item.setUpdatedAt(p.getUpdatedAt());
        return item;
    }
}

