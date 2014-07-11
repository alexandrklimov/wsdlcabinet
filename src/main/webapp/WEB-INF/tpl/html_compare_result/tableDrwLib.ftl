[#ftl]

[#--
tablesIds - collection all ID of available table.
We will make a decision by this collection about creating a link to an element type table.
--]
[#macro typeCellContent descrRow tablesIds]
    [#if descrRow.typeIsBaseXSD]
        ${descrRow.typeName}
    [#else]
        [#if tablesIds??]
            [#if tablesIds?seq_contains(TYPE_TABLE_ID_PREFIX + descrRow.typeId)]
                <a href="#${TYPE_TABLE_ID_PREFIX + descrRow.typeId}" class="js_scroll_link">
                    ${descrRow.typeName}<br/>
                    [#if descrRow.typeNamespace??]
                    <small>Namespace: ${descrRow.typeNamespace}</small>
                    [/#if]
                </a>
            [#else]
                ${descrRow.typeName}<br/>
                [#if descrRow.typeNamespace??]
                <small>Namespace: ${descrRow.typeNamespace}</small>
                [/#if]
            [/#if]
        [#else]
            ${descrRow.typeName}<br/>
            [#if descrRow.typeNamespace??]
            <small>Namespace: ${descrRow.typeNamespace}</small>
            [/#if]
        [/#if]
    [/#if]
[/#macro]

[#--Here is a macros for a type table title creation--]
[#macro buildTypeTableTitle descrTable]

    [#assign titleCls=""/]
    [#if descrTable.new]
        [#assign titleCls="new"/]
    [#elseif descrTable.removed]
        [#assign titleCls="delete"/]
    [#elseif descrTable.changed]
        [#assign titleCls="changed"/]
    [/#if]

    <h3 class="${titleCls}">
        <a name="${descrTable.id}" class="${titleCls}">
            Type
            [#if descrTable.anonymous]
                ${descrTable.ownerElementName+" element type"}
            [#else]
                ${descrTable.title}
            [/#if]
            [#if descrTable.new]&nbsp;<sup calss="marker_new">(NEW)</sup>[/#if]
        </a>
    </h3>
    <p class="${titleCls}">
        [#if descrTable.anonymous]
            This table describes anonymous type.<br/>
            Owner type:&nbsp;<a href="#${descrTable.ownerTableId}" class="js_scroll_link">${descrTable.ownerTableTitle}</a><br/>
            Owner element:&nbsp;<a href="#${descrTable.ownerTableId}_element_${descrTable.ownerElementName}"class="js_scroll_link">
        ${descrTable.ownerElementName}</a><br/>
            Namespace:&nbsp;${descrTable.typeNamespace}
        [#else]
            Namespace:&nbsp;${descrTable.typeNamespace}
        [/#if]
    </p>
[/#macro]


[#--Here is a macros for a group table title creation--]
[#macro buildGroupTableTitle descrTable]

    [#assign titleCls=""/]
    [#if descrTable.new]
        [#assign titleCls="new"/]
    [#elseif descrTable.changed]
        [#assign titleCls="changed"/]
    [#elseif descrTable.removed]
        [#assign titleCls="delete"/]
    [/#if]

<h3 class="${titleCls}">
    <a name="${descrTable.id}" class="${titleCls}">
        Group ${descrTable.title} [#if descrTable.new]&nbsp;<sup calss="marker_new">(NEW)</sup>[/#if]
    </a>
</h3>
<p class="${titleCls}">
    Namespace:&nbsp;${descrTable.namespace}
</p>
[/#macro]


[#--
Here is a macro creates description about anonymous simple type of an element/attribute for showing it in a DESCRIPTION column
It may be used with compacted model.
--]
[#macro anonTypeInfoInRow row tablesIds]
    [#assign anonSimpleType=row.metaInfo["element_type_table"] /]
<div class="well well-small">
    <strong>Base type:&nbsp;</strong>
    [#if tablesIds?seq_contains(anonSimpleType.baseTypeTableId)]
        <a href="#${anonSimpleType.baseTypeTableId}" class="js_scroll_link">${anonSimpleType.baseTypeName}</a>
    [#else]
    ${anonSimpleType.baseTypeName}
    [/#if]
</div>
<div class="well well-small">
    <p><strong>Facets:</strong></p>
    [#list anonSimpleType.facets as facet]
    <div class="facet_div">
        <span class="pull-left">${facet[0]}</span>
        <span class="pull-right">${facet[1]}</span>
    </div>
    [/#list]
</div>
[/#macro]

[#-- This macros produces one table row describes either an element or an indicator --]
[#macro buildElementRow tableRow tablesIds]
    [#if (tableRow.elemRow)?? ]
        [#--
            The table row represents an one element description.
            This branch is called only from an indicator description branch.
        --]
        [#assign elemRow=tableRow.elemRow ]
        [#assign changeCls=""]
        [#if elemRow.isChangedInType() ||  elemRow.isReplacedType() || elemRow.isNew() || elemRow.isChangeInAttributes() ]
            [#assign changeCls="changed"]
        [#elseif elemRow.isDeleted()]
            [#assign changeCls="deleted"]
        [/#if]
        <tr class="${changeCls}">
            <td>
                <span class="element_anchor">
                    ${elemRow.name!""}&nbsp
                    [#if elemRow.isNew()]
                        <sup calss="marker_new">(NEW)</sup>
                    [/#if]
                </span>
            </td>
            <td>[@typeCellContent elemRow tablesIds/]</td>
            <td>${elemRow.cardinality!""}</td>
            <td>${elemRow.nillable!""}</td>
            <td>
            [#--If we have compacted model--]
                [#if elemRow.metaInfo["element_type_table"]??]
                    [@anonTypeInfoInRow row=elemRow tablesIds=tablesIds/]
                [/#if]
            [#--other info--]
                [#if elemRow.defaultValue?? ]
                    Default value: ${elemRow.defaultValue}<BR/>
                [/#if]
                [#if elemRow.fixedValue?? ]
                    Fixed value: ${elemRow.fixedValue}<BR/>
                [/#if]
                [#if elemRow.documentations?size!=0]
                    [#list elemRow.documentations as doc]
                        <pre>${doc}</pre>
                    [/#list]
                [/#if]
                [#if elemRow.appinfos?size!=0]
                    [#list elemRow.appinfos as appinfo]
                        <pre>${appinfo}</pre>
                    [/#list]
                [/#if]
            </td>
        </tr>
    [#else]
        [#--
            The table row represents an indicator description
        --]
            [@buildIndicatorTable tableRow=tableRow tablesIds=tablesIds /]
    [/#if]

[/#macro]

[#-- 
    This macros produces one table row describes an indicator (all, choice, sequence).
    The row contains a nested table. 
--]
[#macro buildIndicatorTable tableRow tablesIds]
    [#-- CSS class computation --]
    [#assign indRow=tableRow.indicatorDescrRow]
    [#assign changeCls=""]
    [#if indRow.isNew()]
        [#assign changeCls="indicator_new"]
    [#elseif indRow.isDeleted()]
        [#assign changeCls="indicator_deleted"]
    [#else]
        [#if indRow.isChangedInContent()]
            [#if changeCls?has_content ]
                [#assign changeCls = changeCls+ " "]
            [/#if]
            [#assign changeCls = changeCls+"indicator_changed_in_content"]
        [/#if]
        [#if indRow.isChangedInAttributes()]
            [#if changeCls?has_content]
                [#assign changeCls = changeCls+ " "]
            [/#if]
            [#assign changeCls = changeCls+"indicator_changed_in_attributes"]
        [/#if]
    [/#if]
    [#-- END CSS class computation --]
    <tr>
        [#--
            An indicator container table cell that is nested into high-level indicator should swap 5 columns of table
              because indicator table consist of 5 columns.
            For root indicator table it's not true, because of a table of its parent cell contains 4 columns for
              attribute rows.
        --]
        [#assign colspan=5]
        [#if indRow.root][#assign colspan=4][/#if]
        <td colspan="${colspan}" class="indicator_or_group_table_container">
            <table class="table table-bordered indicator_or_nested_grp_view_table ${changeCls}" id="indicator_table-${indRow.id}">
                <thead>
                    <tr class="head_row indicator_or_nested_grp_head">
                        <th class="strong_cell" colspan="5">
                            <div class="clearfix">
                                <div class="pull-left" style="margin-right: 3em;">
                                    ${indRow.indicatorName?upper_case}
                                </div>
                                [#assign attrClass=""/]
                                [#if indRow.changedAttributesNames?seq_contains("minOccurs")][#assign attrClass="changed_attr"/][/#if]
                                <div class="pull-left ${attrClass}" style="margin-right: 3em;">
                                    minOccurs: ${indRow.minOccurs}
                                </div>
                                [#assign attrClass=""/]
                                [#if indRow.changedAttributesNames?seq_contains("maxOccurs")][#assign attrClass="changed_attr"/][/#if]
                                <div class="pull-left ${attrClass}">
                                    maxOccurs: [#if indRow.isUnbounded()]*[#else]${indRow.maxOccurs}[/#if]
                                </div>
                            </div>
                        </th>
                    </tr>
                    <tr class="head_row">
                        [#assign columnNames=["Name", "Type", "Cardinality", "Nillable", "Descr."]/]
                        [#list columnNames as colName]
                            <th>${colName}</th>
                        [/#list]
                    </tr>
                </thead>
                [#list indRow.contentRows as tableRow]
                    [@buildElementRow tableRow=tableRow tablesIds=tablesIds /]
                [/#list]
            </table>
        </td>
    </tr>
[/#macro]


[#-- This macros just generates a html table, without any environment - table-tag and everything between only --]
[#macro complexTypeTable descrTable tablesIds drawAsDeleted=false]
<table class="table table-bordered custom-type-or-group-table [#if drawAsDeleted]deleted_type_table[/#if]">
    [#--Elements rows--]
    [#if (descrTable.rootRow)?? && !(descrTable.rootRow.isEmpty()) ]
        <tr>
            <td colspan="4" class="strong_cell">
                Elements:
            </td>
        </tr>
        [#assign rootRow=descrTable.rootRow /]
        [#if rootRow.rootGroupRefRow]
            [@selectGroupDrawingType elemRow=rootRow.elemRow tablesIds=tablesIds isTypeRootGroup=true/]
        [#else]
            [@buildElementRow tableRow=descrTable.rootRow tablesIds=tablesIds /]
        [/#if]
    [/#if]
    [#--Attributes rows --]
    [#if descrTable.attrRows?size !=0 ]
        <tr>
            <td colspan="4" class="strong_cell">Attributes:</td>
        </tr>
        <tr class="head_row">
            [#assign columnNames=["Name", "Type", "Use", "Descr."]/]
            [#list columnNames as colName]
                <th>${colName}</th>
            [/#list]
        </tr>
        [#list descrTable.attrRows as tblRow]
            [#assign row = tblRow.elemRow]
            [#assign changeCls = ""]
            [#if row.isChangedInType() ||  row.isReplacedType() || row.isNew() || row.isChangeInAttributes() ]
                [#assign changeCls="changed"]
            [#elseif row.isDeleted()]
                [#assign changeCls="deleted"]
            [/#if]
            <tr class="${changeCls}">
                <td>${row.name!""}</td>
                <td>[@typeCellContent row tablesIds/]</td>
                <td>${row.use!"optional"}</td>
                <td>
                    [#--If we have compacted model--]
                    [#if row.metaInfo["element_type_table"]??]
                        [@anonTypeInfoInRow row=row tablesIds=tablesIds/]
                    [/#if]
                    [#--other info--]
                    [#if row.defaultValue?? ]
                        Default value: ${row.defaultValue}<BR/>
                    [/#if]
                    [#if row.fixedValue?? ]
                        Fixed value: ${row.fixedValue}<BR/>
                    [/#if]
                    [#if row.documentations?size!=0]
                        [#list row.documentations as doc]
                            <pre>${doc}</pre>
                        [/#list]
                    [/#if]
                    [#if row.appinfos?size!=0]
                        [#list row.appinfos as appinfo]
                            <pre>${appinfo}</pre>
                        [/#list]
                    [/#if]
                </td>
            </tr>
        [/#list]
    [/#if]
</table>
[/#macro]

[#-- This macros just generates a html table, without any environment - table-tag and everything between only --]
[#macro simpleTypeTable descrTable tablesIds drawAsDeleted=false]
<table  class="table table-bordered [#if drawAsDeleted]deleted_type_table[/#if]">
    <tr>
        <td class="strong_cell">Base type:</td>
        <td>
            [#if descrTable.baseTypeIsBaseXsdType ]
                ${descrTable.baseTypeName}
            [#else]
                <a href="#${descrTable.baseTypeTableId}">${descrTable.baseTypeTableId}</a>
            [/#if]
        </td>
    </tr>
    <tr>
        <td colspan="2" class="strong_cell">Facets:</td>
    </tr>
    <tr class="head_row">
        <td>Facet name</td>
        <td>Facet value</td>
    </tr>
    [#list descrTable.facets as facet]
        <tr>
            <td>${facet[0]}</td>
            <td>${facet[1]}</td>
        </tr>
    [/#list]

</table>
[/#macro]


[#macro selectGroupDrawingType elemRow tablesIds isTypeRootGroup]
    [#if elemRow.grpIncluded]
        [@buildNestedViewOfGroup elemRow tablesIds isTypeRootGroup /]
    [#else]
        [@buildNestedGroupViewAsRef elemRow tablesIds isTypeRootGroup /]
    [/#if]
[/#macro]

[#macro buildNestedViewOfGroup elemRow tablesIds isTypeRootGroup]
    [#assign groupDescrTable = elemRow.metaInfo["GROUP_TYPE_TABLE"] /]
<tr>
    [#--
        A group container table cell that is nested into high-level indicator should swap 5 columns of table
          because indicator table consist of 5 columns.
        For root group table it's not true, because of a table of its parent cell contains 4 columns for
          attribute rows.
    --]
    [#assign colspan=5]
    [#if isTypeRootGroup][#assign colspan=4][/#if]
    [#if groupDescrTable.removed]
        <td colspan="${colspan}" style="margin-left: 1em; margin-right: 1em">
            <strong class="delete">Group ${groupTable.name} has been deleted.</strong>
        </td>
    [#else]
        <td colspan="${colspan}" class="indicator_or_group_table_container">
            <table class="table table-bordered indicator_or_nested_grp_view_table ${changeCls}">
                <thead>
                    <tr class="head_row indicator_or_nested_grp_head">
                        <th class="strong_cell" colspan="4">
                            [#assign headClass=""/]
                            [#if elemRow.new || elemRow.changesInGroup || elemRow.replacedGroup || groupDescrTable.new]
                                [#assign headClass="changed"/]
                            [/#if]
                            <div class="clearfix ${headClass}">
                                <div class="pull-left" style="margin-right: 3em;">
                                    <strong>
                                        Group ${groupDescrTable.name}
                                        [#if elemRow.new && !groupDescrTable.new]
                                            <sup calss="marker_new">(NEW ROW)</sup>
                                        [#elseif groupDescrTable.new]
                                            <sup calss="marker_new">(NEW)</sup>
                                        [/#if]
                                    </strong><br/>
                                    <span style="font-size:80%">Namespace: ${groupDescrTable.namespace}</span>
                                </div>
                                [#assign attrClass=""/]
                                [#if elemRow.changeInAttributes][#assign attrClass="changed_attr"/][/#if]
                                <div class="pull-left ${attrClass}" style="margin-right: 3em;">
                                    minOccurs: ${elemRow.metaInfo["GROUP_REF_MIN_OCCURS"]}
                                </div>
                                <div class="pull-left ${attrClass}">
                                    maxOccurs: ${elemRow.metaInfo["GROUP_REF_MAX_OCCURS"]}
                                </div>
                            </div>
                        </th>
                    </tr>
                </thead>
                [#assign indRow=groupDescrTable.rootRow /]
                [@buildIndicatorTable tableRow=indRow tablesIds=tablesIds /]
            </table>
        </td>
    [/#if]
</tr>
[/#macro]

[#macro buildNestedGroupViewAsRef elemRow tablesIds isTypeRootGroup]
    [#assign groupDescrTable = groupsMap[elemRow.refGroupId] /]
<tr>
    [#--
        A group container table cell that is nested into high-level indicator should swap 5 columns of table
          because indicator table consist of 5 columns.
        For root group table it's not true, because of a table of its parent cell contains 4 columns for
          attribute rows.
    --]
    [#assign colspan=5]
    [#if isTypeRootGroup][#assign colspan=4][/#if]
    <td colspan="${colspan}" style="margin-left: 1em; margin-right: 1em">
        [#assign headClass=""/]
        [#if elemRow.new || elemRow.changesInGroup || elemRow.replacedGroup || groupDescrTable.new]
            [#assign headClass="changed"/]
        [/#if]
        <div class="clearfix ${headClass}">
            <div class="pull-left">
                <a href="#${groupDescrTable.id}" class="js_scroll_link">
                    <strong>
                        Group ${groupDescrTable.name}
                        [#if elemRow.new && !groupDescrTable.new]
                            <sup calss="marker_new">(NEW ROW)</sup>
                        [#elseif groupDescrTable.new]
                            <sup calss="marker_new">(NEW)</sup>
                        [/#if]
                    </strong><br/>
                    Namespace: ${groupDescrTable.namespace}
                </a>
            </div>
            [#assign attrClass=""/]
            [#if elemRow.changeInAttributes][#assign attrClass="changed"/][/#if]
            <div class="pull-left ${attrClass}" style="margin-right: 3em;">
                <strong>
                    minOccurs: ${elemRow.metaInfo["GROUP_REF_MIN_OCCURS"]}
                </strong>
            </div>
            <div class="pull-left ${attrClass}">
                <strong>
                    maxOccurs: ${elemRow.metaInfo["GROUP_REF_MAX_OCCURS"]}
                </strong>
            </div>
        </div>
    </td>
</tr>
[/#macro]


[#macro buildGroupTable groupTable]
[#if groupTable.removed]
    <h4 class="delete">Group ${groupTable.name} has been deleted.</h4>
[#else]
    <table class="table table-bordered custom-type-or-group-table">
    [#--Elements rows--]
        [#if (groupTable.rootRow)?? && !(groupTable.rootRow.isEmpty()) ]
            <tr>
                [#--For existing code reusing save colspan the same as for complex table drawing--]
                <td colspan="4" class="strong_cell">
                    Elements:
                </td>
            </tr>
            [#assign rootRow=groupTable.rootRow /]
            [#if rootRow.rootGroupRefRow]
                [@buildNestedViewOfGroup elemRow=rootRow.elemRow tablesIds=tablesIds isTypeRootGroup=true/]
            [#else]
                [@buildElementRow tableRow=rootRow tablesIds=tablesIds /]
            [/#if]
        [/#if]
    </table>
[/#if]
[/#macro]


[#-- This macros makes decision about what type of description should be produced --]
[#macro tableDrwSelect descrTbl tablesIds drawAsDeleted=false]
    [#if descrTbl.removed]
        <h4 class="delete">Type ${descrTbl.title} has been deleted.</h4>
    [#elseif descrTbl.complexType]
        [@complexTypeTable descrTable=descrTbl tablesIds=tablesIds drawAsDeleted=drawAsDeleted /]
    [#else]
        [@simpleTypeTable descrTable=descrTbl tablesIds=tablesIds drawAsDeleted=drawAsDeleted /]
    [/#if]
[/#macro]