function showPwEvent(){
    var pw = document.getElementsByClassName('pw')[0]

    if (pw.type == 'password'){
        pw.setAttribute('type', 'text')
    }
    else{
        pw.setAttribute('type', 'password')
    }
}

function mainPageEvent(){
    document.location.href = "html/main.jsp"
}