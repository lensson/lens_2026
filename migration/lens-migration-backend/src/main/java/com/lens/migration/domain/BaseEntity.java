package com.lens.migration.domain;

import com.baomidou.mybatisplus.annotation.FieldFill;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

/**
 * 所有实体的公共基类
 *
 * 提供主键（自增 Long）、创建时间、更新时间的统一字段。
 * 使用 MyBatis-Plus MetaObjectHandler 自动填充 createdAt / updatedAt。
 */
@Getter
@Setter
public abstract class BaseEntity {

    /** 主键，数据库自增 */
    @TableId(value = "id", type = IdType.AUTO)
    private Long id;

    /** 记录创建时间，插入时自动填充 */
    @TableField(value = "created_at", fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    /** 记录最后更新时间，插入和更新时自动填充 */
    @TableField(value = "updated_at", fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
