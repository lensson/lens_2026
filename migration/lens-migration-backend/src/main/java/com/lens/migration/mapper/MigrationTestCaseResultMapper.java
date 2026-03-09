package com.lens.migration.mapper;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lens.migration.domain.MigrationTestCaseResult;
import com.lens.migration.domain.enums.TestStatus;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;
@Mapper
public interface MigrationTestCaseResultMapper extends BaseMapper<MigrationTestCaseResult> {
    @Select("SELECT * FROM migration_test_case_result WHERE test_run_id = #{testRunId}")
    List<MigrationTestCaseResult> selectByTestRunId(@Param("testRunId") Long testRunId);
    @Select("SELECT * FROM migration_test_case_result WHERE test_run_id = #{testRunId} AND status = #{status}")
    List<MigrationTestCaseResult> selectByTestRunIdAndStatus(@Param("testRunId") Long testRunId, @Param("status") TestStatus status);
}
