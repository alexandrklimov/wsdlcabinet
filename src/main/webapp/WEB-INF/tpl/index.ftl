[#ftl]
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
        <link rel="stylesheet" type="text/css" href="${contextPath}/resources/bootstrap3/css/bootstrap.min.css">
        <link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/custom-theme/jquery-ui-1.10.3.theme.css">
        <link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/custom-theme/jquery-ui-1.10.3.custom.css">
        <!--[if IE]>
            <link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/custom-theme/jquery.ui.1.10.3.ie.css">
        <![endif]-->
        <link rel="stylesheet" type="text/css" href="${contextPath}/resources/css/custom-ui.css">

        <script type="text/javascript" src="${contextPath}/resources/js/jquery-1.10.2.js"></script>
        <script type="text/javascript" src="${contextPath}/resources/js/jqui/ui/jquery-ui.js"></script>

        <script type="text/javascript">
            $(document).ready(function(){
                $( "#select-input-accordion" ).accordion({ animate: false });
            });
        </script>

    </head>
    <body>
        [#--<div style="margin-left:auto; margin-right:auto; margin-top:2em; margin-bottom:2em; width:40em" class="well">--]
        <div class="col-md-4 col-md-offset-4 well">
            <div id="select-input-accordion">
                <h2>
                    <strong>Compare by files</strong>
                </h2>
                <div>
                    <form action="${contextPath}/compare_files_cntr" method="POST" enctype="multipart/form-data">
                        <fieldset>
                            <div class="form-group">
                                <label>Новый файл</label>
                                <input name="newFile" type="file" style="background-color: #FFFFFF">
                            </div>
                            <div class="form-group">
                                <label>Старый файл</label>
                                <input name="oldFile" type="file" style="background-color: #FFFFFF">
                            </div>
                            <hr/>
                                <div class="checkbox">
                                    <label>
                                        <input type="checkbox" name="compactMode" value="true"> Compact mode
                                    </label>
                                </div>
                            <hr/>
                            <button type="submit" class="btn btn-primary">Сравнить</button>
                        </fieldset>
                    </form>
                </div>
                <h2>
                    <strong>Compare by URLs</strong>
                </h2>
                <div>
                    <form action="${contextPath}/compare_urls_cntr" method="GET">
                        <fieldset>
                            <legend><h4>Новый WSDL</h4></legend>
                            <div class="form-group">
                                <label>URL нового WSDL</label>
                                <input name="newWsdlUrl" type="text" class="form-control" >
                            </div>
                            <div class="form-group">
                                <label>login</label>
                                <input name="newLogin" type="text">
                            </div>
                            <div class="form-group">
                                <label>password</label>
                                <input name="newPassword" type="text">
                            </div>
                        </fieldset>
                        <br/>
                        <fieldset>
                            <legend><h4>Старый WSDL</h4></legend>
                            <div class="form-group">
                                <label>URL старого WSDL</label>
                                <input name="oldWsdlUrl" type="text" class="form-control" >
                            </div>
                            <div class="form-group">
                                <label>login</label>
                                <input name="oldLogin" type="text">
                            </div>
                            <div class="form-group">
                                <label>password</label>
                                <input name="oldPassword" type="text">
                            </div>
                        </fieldset>
                        <hr/>
                        <div class="checkbox">
                            <label>
                                <input type="checkbox" name="compactMode" value="true"> Compact mode
                            </label>
                        </div>
                        <hr/>
                        <button type="submit" class="btn btn-primary">Сравнить</button>
                    </form>
                </div>
            </div>
        </div>

    </body>
</html>
