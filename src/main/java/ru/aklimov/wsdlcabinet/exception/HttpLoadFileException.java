package ru.aklimov.wsdlcabinet.exception;

/**
 * Created by aklimov on 04.07.14.
 */
public class HttpLoadFileException extends RuntimeException{
    public HttpLoadFileException() {
        super();
    }

    public HttpLoadFileException(String message) {
        super(message);
    }

    public HttpLoadFileException(String message, Throwable cause) {
        super(message, cause);
    }

    public HttpLoadFileException(Throwable cause) {
        super(cause);
    }

    protected HttpLoadFileException(String message, Throwable cause, boolean enableSuppression, boolean writableStackTrace) {
        super(message, cause, enableSuppression, writableStackTrace);
    }
}
