$(document).ready(function(){
    var menuItems = new Array();
    $('#main-menu-table td a').each(function(index, item ){
        menuItems[index] = item;
    });
    menuItems.sort( sortByWidth );
    var maxWidth = $(menuItems[menuItems.length-1]).width();
    $('#main-menu-table td a').each(function(index, item ){
        $(this).width(maxWidth);
    });
});

function sortByWidth(a, b){
    var aWidth = $(a).width();
    var bWidth = $(b).width();
    return ((aWidth < bWidth) ? -1 : ((aWidth > bWidth) ? 1 : 0));
}

