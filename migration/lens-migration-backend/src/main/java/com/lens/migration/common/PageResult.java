package com.lens.migration.common;

import lombok.Getter;

import java.util.List;

/**
 * 分页结果包装
 *
 * @param <T> 列表项类型
 */
@Getter
public class PageResult<T> {

    private final List<T> items;
    private final long total;
    private final int page;
    private final int size;
    private final int totalPages;

    public PageResult(List<T> items, long total, int page, int size) {
        this.items = items;
        this.total = total;
        this.page = page;
        this.size = size;
        this.totalPages = size > 0 ? (int) Math.ceil((double) total / size) : 0;
    }
}

