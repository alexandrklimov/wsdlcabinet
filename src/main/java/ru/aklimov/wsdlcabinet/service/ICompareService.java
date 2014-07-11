package ru.aklimov.wsdlcabinet.service;

import org.springframework.web.multipart.MultipartFile;
import ru.aklimov.wsdlcomparator.domain.tblmodel.TablePresentedDescriptor;
import ru.aklimov.wsdlcomparator.domain.tblmodel.TypeDescrTable;

import java.util.Map;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 * User: aklimov
 * Date: 22.05.13
 * Time: 13:40
 * To change this template use File | Settings | File Templates.
 */
public interface ICompareService {

    Map<String, Object> getModels(MultipartFile newFile, MultipartFile oldFile, boolean reqCompactModel);
    Map<String, Object> getModels(byte[] newFileContent, byte[] oldFileContent, boolean reqCompactMode);
    Set<TablePresentedDescriptor> getCompactModels(Set<? extends TablePresentedDescriptor> tables);
    Map<String, Object> getModels(byte[] newFileContent, boolean reqCompactMode);

}
