[#ftl]
[#import "tocDrwLib.ftl" as toc /]
<!DOCTYPE HTML>
<html>
<head>
    <link rel="stylesheet" type="text/css" href="${contextPath}/resources/bootstrap3/css/bootstrap.min.css">
    <link type="text/css" rel="stylesheet" href="${contextPath}/resources/css/custom.css"/>

    <script src="${contextPath}/resources/js/jquery-1.10.2.js"></script>
    <script src="${contextPath}/resources/js/jqui/ui/jquery-ui.js"></script>
    <script src="${contextPath}/resources/js/jquery.scrollto-1.4.3.1-min.js"></script>
    <script src="${contextPath}/resources/js/jquery.localscroll-1.2.7-min.js"></script>
    <script src="${contextPath}/resources/js/jquery.layout-latest.js"></script>
    <script src="${contextPath}/resources/js/jquery-scrollspy.js"></script>
    <script src="${contextPath}/resources/js/html-report-custom.js"></script>
</head>
<body>
    <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
        <a class="navbar-brand" href="${contextPath}">WsdlCabinet</a>
        <ul class="nav navbar-nav">
            <li>
                <button class="btn navbar-btn btn-info" id="toc-toggle-btn">Table of Content</button>
            </li>
        </ul>
    </nav>

    <div class="ui-layout-west">
        [@toc.tocDraw methods=methods types=types/]
    </div>

    <div class="ui-layout-center" id="ui-layout-center">
        [#compress]
            <br/>
            <div class="well well-large">
                <strong>
                    Для исключения из документа избыточной информации, принимается, что входные и выходные параметры методов
                    вебсервисов содержатся в элементах типа request/response,
                    которые называются по имени метода с соответствующим суффиксом &lt;название_метода&gt;Request и
                    &lt;название_метода&gt;Response
                    (например, для метода checkContractForRepayment входным параметром будет элемент checkContractForRepaymentRequest,
                    а выходным checkContractForRepaymentResponse). Это соглашение действует для всех методов, поэтому при описании будет опускаться.
                </strong>
            </div>
            [#include "result_content.ftl"/]
        [/#compress]
    </div>

</body>
</html>