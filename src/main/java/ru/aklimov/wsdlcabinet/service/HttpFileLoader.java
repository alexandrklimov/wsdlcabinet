package ru.aklimov.wsdlcabinet.service;

import org.apache.commons.codec.binary.Base64;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;
import ru.aklimov.wsdlcabinet.exception.HttpLoadFileException;

import java.nio.charset.Charset;
import java.util.Arrays;

/**
 * This class provides a remote file load service.<br>
 * If an attempt of loading a remote file meets with authentication fail(401 ERROR) then
 * this service do one more attempt to load a remote file by a default login/password.
 */
@Component
public class HttpFileLoader implements IHttpFileLoader {
    private static Logger log = LoggerFactory.getLogger(HttpFileLoader.class);

    public static final String BASIC_AUTHORIZATION_HEADER_NAME = "Authorization";
    public static final int MAX_ATTEMPT_COUNT_VAL = 2;

    @Value("#{appProperties['default-remote-login']}")
    private String defaultLogin;
    @Value("#{appProperties['default-remote-password']}")
    private String defaultPassword;

    @Autowired
    private CustomHttpComponentsClientHttpRequestFactory httpRequestFactory;

    @Override
    public byte[] getFile(final String address) {
        return getFile(address, null, null);
    }

    @Override
    public byte[] getFile(final String address, final String login, final String password) {
        return getFile(address, login, password, 1);
    }


    private byte[] getFile(final String address, final String login, final String password, final int attemptCount) {
        log.debug("#getFile: \naddress="+address+" \nattemptCount="+attemptCount);

        RestTemplate restTemplate = new RestTemplate(httpRequestFactory);
        HttpHeaders headers = new HttpHeaders();
        if (login != null && password != null) {
            String basicAuthVal = createBasicAuthHeaderVal(login, password);
            headers.put(BASIC_AUTHORIZATION_HEADER_NAME, Arrays.asList( new String[]{basicAuthVal}));
        }
        HttpEntity entity = new HttpEntity(headers);

        byte[] resBytes;
        try {
            ResponseEntity<byte[]> respEntity = restTemplate.exchange(address, HttpMethod.GET, entity, byte[].class);
            HttpStatus statusCode = respEntity.getStatusCode();

            if(HttpStatus.OK != statusCode){
                throw new HttpLoadFileException("WSDL loading is fail. HTTP status is "+statusCode+". URL address: "+address);
            }
            resBytes = respEntity.getBody();

        } catch(HttpClientErrorException httpEx){
            if(HttpStatus.UNAUTHORIZED == httpEx.getStatusCode() &&
                    attemptCount < MAX_ATTEMPT_COUNT_VAL){
                log.warn("#getFile: Loading a remote file from "+address+" is failed! Doing attempt of loading by a default credentials.");
                resBytes = getFile(address, defaultLogin, defaultPassword, MAX_ATTEMPT_COUNT_VAL);

            } else {
                throw new HttpLoadFileException(httpEx);
            }

        } catch (RestClientException restEx) {
            throw new HttpLoadFileException(restEx);
        }

        return resBytes;
    }


    private String createBasicAuthHeaderVal(final String login, final String password){
        String auth = login + ":" + password;
        byte[] encodedAuth = Base64.encodeBase64( auth.getBytes(Charset.forName("UTF-8")) );
        return "Basic " + new String( encodedAuth );
    }

}
