package ru.aklimov.wsdlcabinet.service;

import java.net.URL;

/**
 * Created by aklimov on 04.07.14.
 */
public interface IHttpFileLoader {
    byte[] getFile(String address);
    byte[] getFile(String address, String login, String password);
}
