[#ftl]
<!DOCTYPE HTML>
<html>
    <body>
        <h1>Ooops!</h1>
        [#if errorMsg??]
            <p>${errorMsg}</p>
        [/#if]
        [#if errorMsgLst??]
            <ul>
            [#list errorMsgLst as msg]
                <li>${msg}</li>
            [/#list]
            </ul>
        [/#if]
    </body>
</html>