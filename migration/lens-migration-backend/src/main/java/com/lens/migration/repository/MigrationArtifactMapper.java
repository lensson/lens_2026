package com.lens.migration.repository;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lens.migration.domain.MigrationArtifact;
import com.lens.migration.domain.enums.ArtifactType;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;
@Mapper
public interface MigrationArtifactMapper extends BaseMapper<MigrationArtifact> {
    @Select("SELECT * FROM migration_artifact WHERE project_id = #{projectId}")
    List<MigrationArtifact> selectByProjectId(@Param("projectId") Long projectId);
    @Select("SELECT * FROM migration_artifact WHERE project_id = #{projectId} AND artifact_type = #{artifactType}")
    List<MigrationArtifact> selectByProjectIdAndType(@Param("projectId") Long projectId, @Param("artifactType") ArtifactType artifactType);
    @Select("SELECT * FROM migration_artifact WHERE project_id = #{projectId} AND artifact_type = #{artifactType} AND is_active = 1 LIMIT 1")
    MigrationArtifact selectActiveByProjectIdAndType(@Param("projectId") Long projectId, @Param("artifactType") ArtifactType artifactType);
    @Select("SELECT * FROM migration_artifact WHERE project_id = #{projectId} AND artifact_type = #{artifactType} ORDER BY version DESC LIMIT 1")
    MigrationArtifact selectLatestByProjectIdAndType(@Param("projectId") Long projectId, @Param("artifactType") ArtifactType artifactType);
}
