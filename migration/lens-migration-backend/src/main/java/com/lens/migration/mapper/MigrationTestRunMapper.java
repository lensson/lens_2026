package com.lens.migration.mapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lens.migration.domain.MigrationTestRun;
import com.lens.migration.domain.enums.TestStatus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;
@Mapper
public interface MigrationTestRunMapper extends BaseMapper<MigrationTestRun> {
    @Select("SELECT * FROM migration_test_run WHERE project_id = #{projectId} ORDER BY id DESC")
    List<MigrationTestRun> selectByProjectIdDesc(@Param("projectId") Long projectId);
    @Select("SELECT * FROM migration_test_run WHERE project_id = #{projectId} AND status = #{status}")
    List<MigrationTestRun> selectByProjectIdAndStatus(@Param("projectId") Long projectId, @Param("status") TestStatus status);
    @Select("SELECT * FROM migration_test_run WHERE project_id = #{projectId} ORDER BY id DESC LIMIT 1")
    MigrationTestRun selectLatestByProjectId(@Param("projectId") Long projectId);
    @Select("SELECT * FROM migration_test_run WHERE artifact_id = #{artifactId}")
    List<MigrationTestRun> selectByArtifactId(@Param("artifactId") Long artifactId);
}
