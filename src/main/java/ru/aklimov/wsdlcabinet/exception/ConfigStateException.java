package ru.aklimov.wsdlcabinet.exception;

public class ConfigStateException extends RuntimeException {
    public ConfigStateException() {
    }

    public ConfigStateException(String message) {
        super(message);
    }

    public ConfigStateException(String message, Throwable cause) {
        super(message, cause);
    }

    public ConfigStateException(Throwable cause) {
        super(cause);
    }

    public ConfigStateException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
