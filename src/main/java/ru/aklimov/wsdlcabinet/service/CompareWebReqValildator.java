package ru.aklimov.wsdlcabinet.service;

import org.springframework.web.multipart.MultipartFile;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.LinkedList;
import java.util.List;

public class CompareWebReqValildator {
    static private String XML_FILE_FIRST_LINE_SIGN = "<?xml";

    public List<String> validateFiles(MultipartFile newFile, MultipartFile oldFile){

        List<String> errorsMsgs = new LinkedList<>();
        if(newFile.isEmpty()){
            errorsMsgs.add("New file is empty.");
        }
        if(!errorsMsgs.isEmpty()){
            return errorsMsgs;
        }

        byte[] newFileContent;
        try {
            newFileContent = newFile.getBytes();
        } catch (IOException e) {
            errorsMsgs.add("Can't load a new WSDL file content");
            return errorsMsgs;
        }

        byte[] oldFileContent = new byte[]{};
        if ( ! oldFile.isEmpty()) {
            try {
                oldFileContent = oldFile.getBytes();
            } catch (IOException e) {
                errorsMsgs.add("Can't load an old WSDL file content");
                return errorsMsgs;
            }
        }

        errorsMsgs.addAll( validateXMLSignature(newFileContent, oldFileContent) );

        return errorsMsgs;
    }

    /**
     * Check xml-file firs-line signature
     *
     * @param fileContent a file content as a bytes array
     * @return list of error messages
     */
    public List<String> validateXMLSignature(byte[] fileContent){
        return validateXMLSignature(fileContent, new byte[]{});
    }


    /**
     * Check xml-file firs-line signature
     *
     * @param newFileContent new wsdl file bytes array
     * @param oldFileContent old wsdl file bytes array
     * @return list of error messages
     */
    public List<String> validateXMLSignature(byte[] newFileContent, byte[] oldFileContent) {
        List<String> errorsMsgs = new LinkedList<>();

        try( InputStreamReader isr = new InputStreamReader(new ByteArrayInputStream(newFileContent)) ) {
            char[] buff = new char[5];
            isr.read(buff, 0, 5);
            if(!XML_FILE_FIRST_LINE_SIGN.equals(new String(buff)) ){
                errorsMsgs.add("A new WSDL file is not valid xml file.");
            }

        } catch (IOException e) {
            errorsMsgs.add("Can't read a new WSDL file.");
            e.printStackTrace();
        }

        if(oldFileContent.length != 0){
            try( InputStreamReader isr = new InputStreamReader(new ByteArrayInputStream(oldFileContent)) ) {
                char[] buff = new char[5];
                isr.read(buff, 0, 5);
                if(!XML_FILE_FIRST_LINE_SIGN.equals(new String(buff)) ){
                    errorsMsgs.add("An old WSDL file is not valid xml file.");
                }

            } catch (IOException e) {
                errorsMsgs.add("Can't read an old WSDL file.");
                e.printStackTrace();
            }
        }

        return errorsMsgs;
    }


}
