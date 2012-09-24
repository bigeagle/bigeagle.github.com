var g_bRunIn360se = false;
var g_strSecurityId = null;
try{
    g_strSecurityId = external.twGetRunPath();
    if (g_strSecurityId.toLowerCase().indexOf("360se")>0) g_bRunIn360se = true;
}
catch(e){
    if (!g_bRunIn360se){
        if(navigator.userAgent.toLowerCase().indexOf("360chrome")>0||navigator.userAgent.toLowerCase().indexOf("360ee")>0){
            g_bRunIn360se=true
        }
    }
}
if(document.referrer.indexOf("360.cn")>0){g_bRunIn360se=true}
if(g_bRunIn360se){
    alert("为了您和他人的健康，请勿使用360流氓浏览器访问本站！");
    window.location="https://www.google.com/search?q=360%E6%B5%81%E6%B0%93";
}
