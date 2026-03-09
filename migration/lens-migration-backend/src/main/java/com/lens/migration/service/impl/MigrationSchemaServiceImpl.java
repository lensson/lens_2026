package com.lens.migration.service.impl;

import com.lens.migration.common.BusinessException;
import com.lens.migration.domain.MigrationSchema;
import com.lens.migration.dto.MigrationSchemaDTO;
import com.lens.migration.mapper.MigrationSchemaMapper;
import com.lens.migration.service.MigrationSchemaService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Slf4j
public class MigrationSchemaServiceImpl implements MigrationSchemaService {

    private final MigrationSchemaMapper schemaMapper;

    @Override
    @Transactional
    public MigrationSchemaDTO.Response add(MigrationSchemaDTO.CreateRequest req) {
        MigrationSchema schema = MigrationSchema.builder()
                .projectId(req.getProjectId())
                .fileName(req.getFileName())
                .moduleName(req.getModuleName())
                .schemaVersion(req.getSchemaVersion())
                .isDeviation(req.getIsDeviation() != null ? req.getIsDeviation() : false)
                .storagePath(req.getStoragePath())
                .fileSize(req.getFileSize())
                .checksum(req.getChecksum())
                .remark(req.getRemark())
                .build();
        schemaMapper.insert(schema);
        log.info("Schema 已添加: projectId={}, file={}", req.getProjectId(), req.getFileName());
        return toResponse(schema);
    }

    @Override
    public List<MigrationSchemaDTO.Response> listByProject(Long projectId) {
        return schemaMapper.selectByProjectId(projectId).stream()
                .map(this::toResponse).toList();
    }

    @Override
    public List<MigrationSchemaDTO.Response> listByProjectAndVersion(Long projectId, String schemaVersion) {
        return schemaMapper.selectByProjectIdAndVersion(projectId, schemaVersion).stream()
                .map(this::toResponse).toList();
    }

    @Override
    public MigrationSchemaDTO.Response getById(Long id) {
        MigrationSchema s = schemaMapper.selectById(id);
        if (s == null) throw BusinessException.notFound("MigrationSchema", id);
        return toResponse(s);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (schemaMapper.selectById(id) == null) throw BusinessException.notFound("MigrationSchema", id);
        schemaMapper.deleteById(id);
    }

    private MigrationSchemaDTO.Response toResponse(MigrationSchema s) {
        MigrationSchemaDTO.Response r = new MigrationSchemaDTO.Response();
        r.setId(s.getId());
        r.setProjectId(s.getProjectId());
        r.setFileName(s.getFileName());
        r.setModuleName(s.getModuleName());
        r.setSchemaVersion(s.getSchemaVersion());
        r.setIsDeviation(s.getIsDeviation());
        r.setStoragePath(s.getStoragePath());
        r.setFileSize(s.getFileSize());
        r.setChecksum(s.getChecksum());
        r.setRemark(s.getRemark());
        r.setCreatedAt(s.getCreatedAt());
        return r;
    }
}

