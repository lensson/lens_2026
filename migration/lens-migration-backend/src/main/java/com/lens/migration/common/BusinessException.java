package com.lens.migration.common;

import lombok.Getter;

/**
 * 业务异常
 */
@Getter
public class BusinessException extends RuntimeException {

    private final int code;

    public BusinessException(String message) {
        super(message);
        this.code = 400;
    }

    public BusinessException(int code, String message) {
        super(message);
        this.code = code;
    }

    public static BusinessException notFound(String entity, Long id) {
        return new BusinessException(404, entity + " not found: id=" + id);
    }

    public static BusinessException badRequest(String message) {
        return new BusinessException(400, message);
    }
}

