package com.lens.migration.repository;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lens.migration.domain.MigrationSchema;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;
/**
 * Yang Schema Mapper
 */
@Mapper
public interface MigrationSchemaMapper extends BaseMapper<MigrationSchema> {
    @Select("SELECT * FROM migration_schema WHERE project_id = #{projectId}")
    List<MigrationSchema> selectByProjectId(@Param("projectId") Long projectId);
    @Select("SELECT * FROM migration_schema WHERE project_id = #{projectId} AND schema_version = #{schemaVersion}")
    List<MigrationSchema> selectByProjectIdAndVersion(@Param("projectId") Long projectId, @Param("schemaVersion") String schemaVersion);
    @Select("SELECT * FROM migration_schema WHERE project_id = #{projectId} AND is_deviation = #{isDeviation}")
    List<MigrationSchema> selectByProjectIdAndDeviation(@Param("projectId") Long projectId, @Param("isDeviation") Boolean isDeviation);
    @Select("SELECT * FROM migration_schema WHERE project_id = #{projectId} AND checksum = #{checksum} LIMIT 1")
    MigrationSchema selectByProjectIdAndChecksum(@Param("projectId") Long projectId, @Param("checksum") String checksum);
}
