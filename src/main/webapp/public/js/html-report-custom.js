$(document).ready(function(){
    location.hash = '';

    $('body').layout({
        applyDefaultStyles: true,
        west:{
            size:"auto"
        }
    })
    .addToggleBtn("#toc-toggle-btn","west");

    var contentContainer = $("#ui-layout-center");

    /////////////////////////////////////////////////////////////
    // Smooth scroll with menu items highlighting functionality
    /////////////////////////////////////////////////////////////

    $("#toc").localScroll({
        target: contentContainer,
        hash:true,
        offset: -(parseInt( $("#toc").css('font-size') )*3)
    });

    /*$("#toc a").click(function(){
        if( ! $(this).parent().hasClass("active") ){
            $("#toc a").parent().removeClass("active");
            $(this).parent().toggleClass("active");
        }
    });*/

    ///////////////////////////////////
    // Scrollspy functionality
    ///////////////////////////////////

        //We need some offset for activation a section before scroll offset will be equal top/bottom position
        //This offset lifts sensitive area of a section higher but leaves the section at its position.
    var offset = (parseInt( $("#toc").css('font-size') )*4);
        //We need some bottom padding area for content container so that an user to be able scroll down some more
        //and the scroll offset fall into the last section sensitive area.
    $("<div style='height:"+parseInt(contentContainer.height()/1.5)+"px'>&nbsp;</div>").appendTo(contentContainer);

    $("div.section").each(function(i) {
        var position = $(this).position();
        console.log(position);
        console.log("min: " + position.top + " / max: " + parseInt(position.top + $(this).height()));
        $(this).scrollspy({
            container: contentContainer,
            min: position.top - offset,
            max: position.top + $(this).outerHeight() - offset,
            onEnter: function(element, position) {
                if(console) console.log("entering " +  element.id );
                var linkTOCHref = new String(element.id).replace("section_", "");
                if(console){
                    console.log("active TOC link id " +  linkTOCHref);
                }
                if( ! $("#toc a[href='#"+linkTOCHref+"']").parent().hasClass("active") ){
                    $("#toc a[href='#"+linkTOCHref+"']").parent().toggleClass("active");
                }
            },
            onLeave: function(element, position) {
                if(console) console.log('leaving ' +  element.id);
                var linkTOCHref = new String(element.id).replace("section_", "");
                $("#toc a[href='#"+linkTOCHref+"']").parent().removeClass("active");
            }
        });
    });

    ///////////////////////////////////
    // Intelligence scroll to anchor link target functionality
    ///////////////////////////////////

    $(".js_scroll_link").click(function() {
        var targetPos = parseInt( $('#content .section a[name="' + $.attr(this, 'href').substr(1) + '"]').position().top );
        var resTargetPos = targetPos + contentContainer.scrollTop() - offset+(offset/4);
        if(console){
            console.log("Content container scrollTop: "+contentContainer.scrollTop()+" | target position: "+targetPos+" | result target: "+resTargetPos);
        }
        //alert();
        contentContainer.animate({
            scrollTop: resTargetPos
        }, 300);
        return false;
    });

});