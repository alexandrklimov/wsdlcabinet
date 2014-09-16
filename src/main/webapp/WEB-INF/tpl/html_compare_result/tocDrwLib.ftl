[#ftl]
[#macro tocDraw portTypesMap types]
[#compress]
    <div id="toc" class="well">
        <ul>
            <li>
                <h4><a href="#port_types_anchor">Port Types</a></h4>
                <ul>
                    [#list portTypesMap?keys as portType]
                    <li>
                        <h5><a href="#${portType+'_port_type'}">${portType}</a></h5>
                        <ul>
                            [#assign methods=portTypesMap[portType] /]
                            [#list methods as method]
                                [@drawMethodToc method/]
                            [/#list]
                        </ul>
                    </li>
                    [/#list]
                </ul>
            </li>
            <li>
                <h4><a href="#types_anchor">Types</a></h4>
                <ul>
                    [#list types as type]
                        <li>
                            <a href="#${type.id}"
                               [#if type.new || type.changed]
                                   class="changed"
                               [#elseif type.removed]
                                   class="toc_deleted"
                               [/#if]
                            >
                                ${type.title}[#if type.new]&nbsp;(NEW)[/#if]
                            </a>
                        </li>
                    [/#list]
                </ul>
            </li>
            [#if groups?? && (groups?size != 0)]
            <li>
                <h4><a href="#groups_anchor">Groups</a></h4>
                <ul>
                    [#list groups as group]
                        [#assign class=""/]
                        [#if group.new || group.changed]
                            [#assign class="changed"/]
                        [#elseif group.removed]
                            [#assign class="toc_deleted"/]
                        [/#if]
                        <li>
                            <a href="#${group.id}" class="${class}" >
                                ${group.title}[#if group.new]&nbsp;(NEW)[/#if]
                            </a>
                        </li>
                    [/#list]
                </ul>
            </li>
            [/#if]
        </ul>
    </div>
[/#compress]
[/#macro]


[#macro drawMethodToc method]
[#compress]
<li>
    <h6 [#if method.changeType?? && method.changeType!="DELETE"]class="new"[/#if]>
        <a href="#${method.methodName+'_operation'}">
        ${method.methodName}[#if method.changedType?? && method.changedType=="NEW"]&nbsp;(NEW)[/#if]
        </a>
    </h6>
    <ul>
        <li>
            <a href="#${method.methodName+'_input_message'}">
                <h7>Input message</h7>
            </a>
        </li>
        [#if method.outputMessage?? && method.outputMessage?size != 0]
            <li>
                <a href="#${method.methodName+'_output_message'}"
                    [#if method.changeType?? && method.changeType!="NEW"]
                        [#if method.changeType == "RESPONSE_ADD"]
                   class="new"
                        [#elseif method.changeType == "RESPONSE_DEL"]
                   class="toc_deleted"
                        [/#if]
                    [#elseif method.changeType?? && method.changeType=="NEW"]
                   class="new"
                    [/#if]
                        >
                    <h7>Output message[#if method.changeType?? && method.changeType == "RESPONSE_ADD"]&nbsp;(NEW)[/#if]</h7>
                </a>
            </li>
        [/#if]
    </ul>
</li>
[/#compress]
[/#macro]
