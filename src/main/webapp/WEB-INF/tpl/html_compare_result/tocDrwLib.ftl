[#ftl]
[#macro tocDraw methods types]
[#compress]
    <div id="toc" class="well">
        <ul>
            <li>
                <h4><a href="#ws_methods_anchor">Methods</a></h4>
                <ul>
                    [#list methods as method]
                        <li>
                            <h5 [#if method.changeType?? && method.changeType!="DELETE"]class="new"[/#if]>
                                <a href="#${method.methodName}">
                                    ${method.methodName}[#if method.changedType?? && method.changedType=="NEW"]&nbsp;(NEW)[/#if]
                                </a>
                            </h5>
                            <ul>
                                <li>
                                    <a href="#${method.methodName+'_input_param'}"
                                        [#if method.changeType?? && method.changeType!="NEW"]
                                            [#if method.requestParams.isNew()]
                                                class="new"
                                            [#elseif method.requestParams.isChanged()]
                                                class="changed"
                                            [/#if]
                                        [#elseif method.changeType?? && method.changeType=="NEW"]
                                            class="new"    
                                        [/#if]                                       
                                    >
                                        Input parameters
                                    </a>
                                </li>
                                [#if method.responseParams??]
                                    <li>
                                        <a href="#${method.methodName+'_output_param'}"
                                            [#if method.changeType?? && method.changeType!="NEW"]
                                                [#if method.responseParams.isNew()]
                                                    class="new"
                                                [#elseif method.responseParams.isChanged()]
                                                    class="changed"
                                                [/#if]
                                            [#elseif method.changeType?? && method.changeType=="NEW"]
                                                class="new"
                                            [/#if]
                                        >
                                            Output parameters[#if method.responseParams.isNew()]&nbsp;(NEW)[/#if]
                                        </a>
                                    </li>
                                [/#if]
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
