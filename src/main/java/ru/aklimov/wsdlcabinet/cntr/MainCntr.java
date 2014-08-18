package ru.aklimov.wsdlcabinet.cntr;

import org.springframework.util.StringUtils;
import org.xml.sax.InputSource;
import ru.aklimov.wsdlcabinet.CompareWsdlByURLDto;
import ru.aklimov.wsdlcabinet.service.CompareWebReqValildator;
import ru.aklimov.wsdlcabinet.service.ICompareService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import ru.aklimov.wsdlcabinet.service.IHttpFileLoader;
import ru.aklimov.wsdlcomparator.domain.CompareResult;
import ru.aklimov.wsdlcomparator.facades.ICompFacade;

import java.io.ByteArrayInputStream;
import java.util.*;


@Controller
public class MainCntr {
    static final private Logger log = LoggerFactory.getLogger(MainCntr.class);

    @Autowired
    CompareWebReqValildator compareWebReqValild;
    @Autowired
    IHttpFileLoader httpFileLoaderl;
    @Autowired
    ICompareService compService;
    @Autowired
    ICompFacade compFacade;


    @RequestMapping(value = {"/","/index"})
    public String index(){
        return "index";
    }

    @RequestMapping(value="/compare_files_cntr", method= RequestMethod.POST)
    public String compareFiles(@RequestParam("newFile")MultipartFile newFile,
                                @RequestParam("oldFile")MultipartFile oldFile,
                                @RequestParam(value="compactMode", required=false, defaultValue="false")Boolean reqCompactMode,
                                Model model){

        List<String> errsMsg = compareWebReqValild.validateFiles(newFile, oldFile);
        if(!errsMsg.isEmpty()){
            model.addAttribute("error", true);
            model.addAttribute("errorMsgLst", errsMsg);
        } else {
            model.addAttribute("error", false);
            try{
                Map<String, Object> models = null;
                if (oldFile.isEmpty()) {
                    models = compService.getModels(newFile.getBytes(), reqCompactMode);
                } else {
                    models = compService.getModels(newFile, oldFile, reqCompactMode);
                }

                fillResultModel(model, models);

                return "html_compare_result/compare_result_layout";

            } catch(Exception ex){
                model.addAttribute("error", true);
                model.addAttribute("errorMsg", ex.getMessage());
                log.error("", ex);
            }
        }

        return "error";
    }


    @RequestMapping("/compare_urls_cntr")
    public String compareURLS(@ModelAttribute CompareWsdlByURLDto params,
                               Model model){

        List<String> errsMsg = new LinkedList<>();

        if( ! StringUtils.hasText(params.getNewWsdlUrl())){
            errsMsg.add("New WSDL URL has to be set.");
        }

        final String newLogin = params.getNewLogin();
        final String newPassword = params.getNewPassword();
        final String oldLogin = params.getOldLogin();
        final String oldPassword = params.getOldPassword();


        try{
            byte[] newWsdlContent = httpFileLoaderl.getFile(params.getNewWsdlUrl(), newLogin, newPassword);

            byte[] oldWsdlContent = new byte[]{};
            if( StringUtils.hasText(params.getOldWsdlUrl()) ){
                oldWsdlContent = httpFileLoaderl.getFile(params.getOldWsdlUrl(), oldLogin, oldPassword);
            }

            if(oldWsdlContent.length == 0){
                List<String> errors = compareWebReqValild.validateXMLSignature(newWsdlContent);
                errsMsg.addAll(errors);
            } else {
                List<String> errors = compareWebReqValild.validateXMLSignature(newWsdlContent, oldWsdlContent);
                errsMsg.addAll(errors);
            }

            Map<String, Object> models = null;
            if (oldWsdlContent.length == 0) {
                models = compService.getModels(newWsdlContent, params.isCompactMode());
            } else {
                models = compService.getModels(newWsdlContent, oldWsdlContent, params.isCompactMode());
            }

            fillResultModel(model, models);

            return "html_compare_result/compare_result_layout";

        } catch(Exception ex){
            model.addAttribute("error", true);
            model.addAttribute("errorMsg", ex.getMessage());
            log.error("", ex);
        }

        if(!errsMsg.isEmpty()){
            model.addAttribute("error", true);
            model.addAttribute("errorMsgLst", errsMsg);
        } else {
            model.addAttribute("error", false);

        }

        return "error";
    }

    @RequestMapping(value = "/check_wsdl_for_changes", method = RequestMethod.POST)
    @ResponseBody
    public String checkWSDLForChanges(@RequestParam("newFile")MultipartFile newFile,
                                  @RequestParam("oldFile")MultipartFile oldFile){
        List<String> errsMsg = compareWebReqValild.validateFiles(newFile, oldFile);
        if(!errsMsg.isEmpty()){
            for(String msg: errsMsg){
                log.error(msg);
            }
        } else {
            try{
                Map<String, Object> models = null;
                if (oldFile.isEmpty() || newFile.isEmpty()) {
                    String errMsg = "Both files must not be empty!";
                    log.error(errMsg);
                    return errMsg;

                } else {
                    InputSource newInSour = new InputSource( new ByteArrayInputStream(newFile.getBytes()) );
                    InputSource oldInSour = new InputSource( new ByteArrayInputStream(oldFile.getBytes()) );
                    CompareResult compareResult = compFacade.fullCompare(newInSour, null, oldInSour, null);
                    if(compareResult.getGroupsDiff().isEmpty() &&
                            compareResult.getTypesDiff().isEmpty() &&
                            compareResult.getWsMethodDiff().isEmpty()){
                        return Boolean.TRUE.toString();

                    } else {
                        return Boolean.FALSE.toString();

                    }

                }

            } catch(Exception ex){
                log.error("", ex);
            }
        }

        return "ERROR";
    }


    private void fillResultModel(Model model, Map<String, Object> models) {
        if (models.containsKey("methods")) {
            model.addAttribute( "methods", new LinkedList((Collection) models.get("methods")) );
        }
        if (models.containsKey("types")) {
            model.addAttribute( "types", new LinkedList((Collection) models.get("types")) );
        }
        if (models.containsKey("groups")) {
            model.addAttribute( "groups", new LinkedList((Collection) models.get("groups")) );
            model.addAttribute( "groupsMap", models.get("groupsMap") );
        }
        if (models.containsKey("tablesIds")) {
            model.addAttribute( "tablesIds", new LinkedList((Collection) models.get("tablesIds")) );
        }
    }

}
