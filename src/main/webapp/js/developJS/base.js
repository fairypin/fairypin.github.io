$(document).ready(function(){
    $(".navigation a").each(function(i,e) {
        if(e.getAttribute("href") ==window.location.pathname) {
            // alert(e.getAttribute("href"));
            $(this).addClass("m-btn-plain-active");
        }
    })
});