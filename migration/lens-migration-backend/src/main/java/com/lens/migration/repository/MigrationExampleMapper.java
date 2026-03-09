package com.lens.migration.repository;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lens.migration.domain.MigrationExample;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;
@Mapper
public interface MigrationExampleMapper extends BaseMapper<MigrationExample> {
    @Select("SELECT * FROM migration_example WHERE project_id = #{projectId}")
    List<MigrationExample> selectByProjectId(@Param("projectId") Long projectId);
    @Select("SELECT * FROM migration_example WHERE project_id = #{projectId} AND operation_type = #{operationType}")
    List<MigrationExample> selectByProjectIdAndOperation(@Param("projectId") Long projectId, @Param("operationType") String operationType);
}
