package ru.aklimov.wsdlcabinet.service;

import org.apache.http.conn.ssl.AllowAllHostnameVerifier;
import org.apache.http.conn.ssl.SSLConnectionSocketFactory;
import org.apache.http.conn.ssl.SSLContexts;
import org.apache.http.conn.ssl.TrustStrategy;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.springframework.http.client.HttpComponentsClientHttpRequestFactory;
import org.springframework.stereotype.Component;

import javax.net.ssl.SSLContext;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.X509Certificate;

/**
 * Created by aklimov on 04.07.14.
 */
@Component
public class CustomHttpComponentsClientHttpRequestFactory extends HttpComponentsClientHttpRequestFactory {

    public CustomHttpComponentsClientHttpRequestFactory() throws UnrecoverableKeyException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException {
        CloseableHttpClient httpClient = HttpClientBuilder.
                create().
                setSSLSocketFactory(createSSLSocketFactory()).
                setHostnameVerifier(new AllowAllHostnameVerifier()).
                useSystemProperties().
                build();
        this.setHttpClient(httpClient);
    }

    private SSLConnectionSocketFactory createSSLSocketFactory() throws NoSuchAlgorithmException, KeyManagementException, UnrecoverableKeyException, KeyStoreException {
        SSLContext sslContext = SSLContexts.custom()
                .useSSL()
                .loadTrustMaterial(null,
                                new TrustStrategy() {
                                        @Override
                                        public boolean isTrusted(final X509Certificate[] chain, String authType){return true;}
                                   }
                ).build();
        SSLConnectionSocketFactory sslsf = new SSLConnectionSocketFactory(sslContext);
        return sslsf;
    }
}
