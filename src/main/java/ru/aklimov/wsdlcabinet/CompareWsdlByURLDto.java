package ru.aklimov.wsdlcabinet;

import org.springframework.web.multipart.MultipartFile;

/**
 * Created by aklimov on 06.07.14.
 */
public class CompareWsdlByURLDto {
    private String newWsdlUrl;
    private String newLogin;
    private String newPassword;
    private String oldWsdlUrl;
    private String oldLogin;
    private String oldPassword;
    private boolean compactMode;


    public String getNewLogin() {
        return newLogin;
    }

    public void setNewLogin(String newLogin) {
        this.newLogin = newLogin;
    }

    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    public String getOldLogin() {
        return oldLogin;
    }

    public void setOldLogin(String oldLogin) {
        this.oldLogin = oldLogin;
    }

    public String getOldPassword() {
        return oldPassword;
    }

    public void setOldPassword(String oldPassword) {
        this.oldPassword = oldPassword;
    }

    public boolean isCompactMode() {
        return compactMode;
    }

    public void setCompactMode(boolean compactMode) {
        this.compactMode = compactMode;
    }

    public String getNewWsdlUrl() {
        return newWsdlUrl;
    }

    public void setNewWsdlUrl(String newWsdlUrl) {
        this.newWsdlUrl = newWsdlUrl;
    }

    public String getOldWsdlUrl() {
        return oldWsdlUrl;
    }

    public void setOldWsdlUrl(String oldWsdlUrl) {
        this.oldWsdlUrl = oldWsdlUrl;
    }
}
