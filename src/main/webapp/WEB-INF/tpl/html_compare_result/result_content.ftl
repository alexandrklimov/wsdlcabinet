[#ftl]
[#import "tableDrwLib.ftl" as my]
[#import "methodDrwLib.ftl" as tools]

[#compress]
<div id="content">
    <p class="break_par">&nbsp;</p>
    <p class="break_par">&nbsp;</p>

    <h2 class="alert alert-info"><a name="ws_methods_anchor">Webservices methods</a></h2>
    <p class="break_par">&nbsp;</p>
    [#list methods as method]
        [@tools.printMethod method=method/]
    [/#list]

    <p class="break_par">&nbsp;</p>
    <h2 class="alert alert-info"><a name="types_anchor">Types and enumerations</a></h2>
    <p class="break_par">&nbsp;</p>

    [#list types as descrTbl]
        <div class="panel type_or_group_section section" id="section_${descrTbl.id}">
            [@my.buildTypeTableTitle descrTable=descrTbl/]
            [@my.tableDrwSelect descrTbl tablesIds/]
        </div>
        <p class="break_par">&nbsp;</p>
    [/#list]

    [#if groups?? && (groups?size != 0)]
        <h2 class="alert alert-info"><a name="groups_anchor">Groups</a></h2>
        <p class="break_par">&nbsp;</p>

        [#list groups as descrTbl]
            <div class="panel type_or_group_section section" id="section_${descrTbl.id}">
                [@my.buildGroupTableTitle descrTable=descrTbl/]
                [@my.buildGroupTable groupTable=descrTbl/]
            </div>
            <p class="break_par">&nbsp;</p>
        [/#list]
    [/#if]
</div>
[/#compress]