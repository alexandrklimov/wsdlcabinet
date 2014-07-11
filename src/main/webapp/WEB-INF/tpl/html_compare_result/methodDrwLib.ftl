[#ftl]
[#import "tableDrwLib.ftl" as my/]

[#macro printMethod method]
<div class="panel type_or_group_section section" id="section_${method.methodName}">
    [#if method.changeType?? && method.changeType!="DELETE"]
        <h3 [#if method.changeType=="NEW"]class="new"[/#if]>
            <a name="${method.methodName}">
                Method ${method.methodName}
            </a>
            [#if method.changeType=="NEW"]&nbsp;<sup calss="custom_sup">(NEW)</sup>[/#if]
        </h3>

        [#-- A request must be presented--]
        <div class="section" id="section_${method.methodName+'_input_param'}">
            <h4>
                <a name="${method.methodName+'_input_param'}">Input parameters:</a>
            </h4>
            [@my.tableDrwSelect method.requestParams tablesIds /]
        </div>

        [#-- A response may be not presented --]
        [#if method.responseParams??]
            <div class="section" id="section_${method.methodName+'_output_param'}">
                <p class="break_par">&nbsp;</p>
                [#if method.changeType=="RESPONSE_ADD"]
                    <h4 class="new">
                [#elseif method.changeType=="RESPONSE_DEL"]
                    <h4 class="delete">
                [#else]
                    <h4>
                [/#if]
                    <a name="${method.methodName+'_output_param'}">
                        Output parameters
                        [#if method.changeType=="RESPONSE_ADD"]&nbsp;<sup calss="marker_new">(NEW)</sup>[/#if]:
                    </a>
                </h4>
                [#if method.changeType=="RESPONSE_DEL"]
                    [@my.tableDrwSelect method.responseParams tablesIds true/]
                [#else]
                    [@my.tableDrwSelect method.responseParams tablesIds/]
                [/#if]
            </div>
        [/#if]
    [#elseif method.changeType?? && method.changeType=="DELETE"]
        <h3>Method ${method.methodName} has been deleted.</h3>
    [#else]
        <h3>
            <a name="${method.methodName}">Method ${method.methodName}</a>
        </h3>
        [#-- A request must be presented--]
        <div class="section" id="section_${method.methodName+'_input_param'}">
            <h4>
                <a name="${method.methodName+'_input_param'}">Input parameters:</a>
            </h4>
            [@my.tableDrwSelect method.requestParams tablesIds /]
        </div>
        [#-- A request may be not presented --]
        [#if method.responseParams??]
            <p class="break_par">&nbsp;</p>
            <div class="section" id="section_${method.methodName+'_output_param'}">
                <h4>
                    <a name="${method.methodName+'_output_param'}">Output parameters</a>
                </h4>
                [@my.tableDrwSelect method.responseParams tablesIds/]
            </div>
        [/#if]

    [/#if]
</div>
<p style="line-height: 3em">&nbsp;</p>
[/#macro]


