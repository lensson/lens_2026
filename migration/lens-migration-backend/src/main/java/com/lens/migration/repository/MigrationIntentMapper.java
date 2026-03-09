package com.lens.migration.repository;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lens.migration.domain.MigrationIntent;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;
@Mapper
public interface MigrationIntentMapper extends BaseMapper<MigrationIntent> {
    @Select("SELECT * FROM migration_intent WHERE project_id = #{projectId} ORDER BY version DESC")
    List<MigrationIntent> selectByProjectIdOrderByVersionDesc(@Param("projectId") Long projectId);
    @Select("SELECT * FROM migration_intent WHERE project_id = #{projectId} AND is_active = 1 LIMIT 1")
    MigrationIntent selectActiveByProjectId(@Param("projectId") Long projectId);
    @Select("SELECT * FROM migration_intent WHERE project_id = #{projectId} ORDER BY version DESC LIMIT 1")
    MigrationIntent selectLatestByProjectId(@Param("projectId") Long projectId);
}
