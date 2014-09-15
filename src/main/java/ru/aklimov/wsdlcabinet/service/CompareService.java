package ru.aklimov.wsdlcabinet.service;

import ru.aklimov.wsdlcomparator.domain.tblmodel.method.WSMethodDescrTable;
import ru.aklimov.wsdlcomparator.modelbuilders.PostCreationUtils;
import ru.aklimov.wsdlcomparator.modelbuilders.ViewModelCreator;
import ru.aklimov.wsdlcomparator.WSDLProcessor;
import ru.aklimov.wsdlcomparator.domain.tblmodel.*;
import ru.aklimov.wsdlcomparator.domain.CompareResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.multipart.MultipartFile;
import org.xml.sax.InputSource;
import ru.aklimov.wsdlcomparator.facades.ICompFacade;
import ru.aklimov.wsdlcomparator.facades.IMethodModelCreatorFacade;
import ru.aklimov.wsdlcomparator.facades.ITypeModelCreatorFacade;

import java.io.ByteArrayInputStream;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

/**
 * Created with IntelliJ IDEA.
 * User: aklimov
 * Date: 22.05.13
 * Time: 13:42
 * To change this template use File | Settings | File Templates.
 */
public class CompareService implements ICompareService {
    @Autowired
    ViewModelCreator viewModelCreator;
    @Autowired
    IMethodModelCreatorFacade methodModelCreator;
    @Autowired
    ITypeModelCreatorFacade typeModelCreatorFacade;
    @Autowired
    ICompFacade compFacade;

    @Override
    public Map<String, Object> getModels(MultipartFile newFile, MultipartFile oldFile, boolean reqCompactModel) {
        Map<String, Object> resMap = null;
        try{
            resMap = getModels( newFile.getBytes(), oldFile.getBytes(), reqCompactModel);
        }catch(Exception ex){
            throw new RuntimeException(ex);
        }
        return resMap;
    }

    @Override
    public Map<String, Object> getModels(byte[] newFileContent, byte[] oldFileContent, boolean reqCompactMode) {

        if(newFileContent==null || oldFileContent==null){
            throw new IllegalArgumentException("One of arguments is null.");
        }

        InputSource newInSour = new InputSource( new ByteArrayInputStream(newFileContent) );
        InputSource oldInSour = new InputSource( new ByteArrayInputStream(oldFileContent) );

        Map<String, Object> resMap = new HashMap<>();
        try{

            CompareResult fullCompareRes = compFacade.fullCompare(newInSour, null, oldInSour, null);

            ModelBuildResult modelByDiffInfoSet = typeModelCreatorFacade.createModelByDiffInfoSet(fullCompareRes.getTypesDiff(), fullCompareRes.getGroupsDiff());

            if (reqCompactMode) {
                Set<TablePresentedDescriptor> tablesForProcessing = new HashSet<>();
                tablesForProcessing.addAll(modelByDiffInfoSet.getTableGroupSet());
                tablesForProcessing.addAll(modelByDiffInfoSet.getTableTypeSet());

                Set<TablePresentedDescriptor> compactedTables = getCompactModels(tablesForProcessing);

                Map<Class<? extends TablePresentedDescriptor>, Set<? extends TablePresentedDescriptor>> classSetMap = splitModelByType(compactedTables);
                modelByDiffInfoSet.setTableTypeSet((Set<TypeDescrTable>) classSetMap.get(TypeDescrTable.class));
                modelByDiffInfoSet.setTableGroupSet((Set<GroupDescrTable>) classSetMap.get(GroupDescrTable.class));
            }

            Set<WSMethodDescrTable> wsMethods = methodModelCreator.createWSMethodModelByDiffInfo(fullCompareRes.getWsMethodDiff(), modelByDiffInfoSet.getTableTypeSet(), modelByDiffInfoSet.getTableGroupSet());
            Set<TypeDescrTable> filteredTables = PostCreationUtils.filterTableSetFromMessagePartTypes(modelByDiffInfoSet.getTableTypeSet(), wsMethods);

            Set<String> tableIds = new HashSet<>();
            tableIds.addAll( getTableIdsSet( modelByDiffInfoSet.getTableTypeSet() ) );
            tableIds.addAll( getGroupIdsSet( modelByDiffInfoSet.getTableGroupSet() ) );

            resMap.put("methods", wsMethods);
            resMap.put("types", filteredTables);
            resMap.put("groups", modelByDiffInfoSet.getTableGroupSet());
            resMap.put("tablesIds", tableIds);
            resMap.put("groupsMap", buildGroupDescrTableMap(modelByDiffInfoSet.getTableGroupSet()) );

        } catch(Exception ex){
            throw new RuntimeException(ex);
        }

        return resMap;
    }

    private Map<Class<? extends TablePresentedDescriptor>, Set<? extends TablePresentedDescriptor>> splitModelByType(Set<TablePresentedDescriptor> compactedTables) {
        Set<TypeDescrTable> compactedTableTypeSet = new HashSet<>();
        Set<GroupDescrTable> compactedTableGroupSet = new HashSet<>();
        for (TablePresentedDescriptor tpd : compactedTables){
            if(tpd instanceof TypeDescrTable){
                compactedTableTypeSet.add((TypeDescrTable) tpd);
            } else if(tpd instanceof GroupDescrTable){
                compactedTableGroupSet.add((GroupDescrTable) tpd);
            }
        }

        Map<Class<? extends TablePresentedDescriptor>, Set<? extends TablePresentedDescriptor>> resMap = new HashMap<>();
        resMap.put(TypeDescrTable.class, compactedTableTypeSet);
        resMap.put(GroupDescrTable.class, compactedTableGroupSet);

        return resMap;
    }


    public Map<String, Object> getModels(byte[] newFileContent, final boolean reqCompactMode) {

        if(newFileContent==null){
            throw new IllegalArgumentException("One of arguments is null.");
        }

        InputSource newInSour = new InputSource( new ByteArrayInputStream(newFileContent) );

        Map<String, Object> resMap = new HashMap<>();
        try{

            WSDLProcessor.WSDLProcessingResult wsdlProcessingResult = compFacade.processWSDL(newInSour, null);
            ModelBuildResult modelsBySet = typeModelCreatorFacade.createModelBySet(wsdlProcessingResult.getDescriptorContainer().getTypeDescriptors(), wsdlProcessingResult.getDescriptorContainer().getGroupDescriptors());

            if (reqCompactMode) {
                Set<TablePresentedDescriptor> tablesForProcessing = new HashSet<>();
                tablesForProcessing.addAll(modelsBySet.getTableGroupSet());
                tablesForProcessing.addAll(modelsBySet.getTableTypeSet());

                Set<TablePresentedDescriptor> compactedTables = getCompactModels(tablesForProcessing);

                Map<Class<? extends TablePresentedDescriptor>, Set<? extends TablePresentedDescriptor>> classSetMap = splitModelByType(compactedTables);
                modelsBySet.setTableTypeSet((Set<TypeDescrTable>) classSetMap.get(TypeDescrTable.class));
                modelsBySet.setTableGroupSet((Set<GroupDescrTable>) classSetMap.get(GroupDescrTable.class));
            }

            Set<WSMethodDescrTable> wsMethods = methodModelCreator.createWSMethodModelByWSMethodDescr(wsdlProcessingResult.getWsMethodDescr(), modelsBySet.getTableTypeSet(), modelsBySet.getTableGroupSet());
            Set<TypeDescrTable> filteredTables = PostCreationUtils.filterTableSetFromMessagePartTypes(modelsBySet.getTableTypeSet(), wsMethods);

            Set<String> tableIds = new HashSet<>();
            tableIds.addAll( getTableIdsSet( modelsBySet.getTableTypeSet() ) );
            tableIds.addAll( getGroupIdsSet( modelsBySet.getTableGroupSet() ) );

            resMap.put("methods", wsMethods);
            resMap.put("types", filteredTables);
            resMap.put("groups", modelsBySet.getTableGroupSet());
            resMap.put("tablesIds", tableIds);
            resMap.put("groupsMap", buildGroupDescrTableMap(modelsBySet.getTableGroupSet()) );

        } catch(Exception ex){
            throw new RuntimeException(ex);
        }

        return resMap;
    }


    public Set<TablePresentedDescriptor> getCompactModels(Set<? extends TablePresentedDescriptor> tables){
        return PostCreationUtils.compactModel(tables);
    }

    private Set<String> getTableIdsSet(Set<TypeDescrTable> types) {
        Set<String> resSet = new HashSet<>();
        for(TypeDescrTable tbl : types){
            resSet.add(tbl.getId());
        }
        return resSet;
    }

    private Set<String> getGroupIdsSet(Set<GroupDescrTable> groups) {
        Set<String> resSet = new HashSet<>();
        for(GroupDescrTable grp : groups){
            resSet.add(grp.getId());
        }
        return resSet;
    }

    private HashMap<String, GroupDescrTable> buildGroupDescrTableMap(Set<GroupDescrTable> gdtSet){
        HashMap<String, GroupDescrTable> gtdMap = new HashMap<>();
        for(GroupDescrTable gtd : gdtSet){
            gtdMap.put(gtd.getId(), gtd);
        }
        return gtdMap;
    }
}
