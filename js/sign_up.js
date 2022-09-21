// function backLogInEvent(){
//     document.location.href = "../index.jsp"
// }

// function showPwEvent(num){
//     var input = document.getElementsByClassName('input')[num]

//     if (input.type == 'password'){
//         input.setAttribute('type', 'text')
//     }
//     else{
//         input.setAttribute('type', 'password')
//     }
// }

// function checkPwEvent(){
//     var pw = document.getElementsByClassName('input')[1].value
//     var confirm_pw = document.getElementsByClassName('input')[2]

//     console.log('pwcheck:' , pw, confirm_pw)

//     if (pw != confirm_pw.value){
//         confirm_pw.setCustomValidity("비밀번호가 일치하지 않습니다."); 
//         confirm_pw.reportValidity();
//     }
//     else{
//         confirm_pw.setCustomValidity(""); 
//     }
// }

// function idSearchEvent(){
//     var id = document.getElementsByClassName('input')[0]
//     var idValue = document.getElementsByClassName('input')[0].value
// }

// function checkIdEvent(){
//     var id = document.getElementsByClassName('input')[0]
//     var tmp = 0;

//     if (tmp == 0){
//         id.readOnly = true
//         id.style.opacity = '0.5'
//     }
//     else{
//         // 만약에 중복아이디면 입력한 값 없애버리기!!
//         id.value = undefined
//     }
// }