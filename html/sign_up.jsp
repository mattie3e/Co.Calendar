<%@ page language="java" contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<%
    // 이전 페이지로부터 온 값 인코딩 설정
    request.setCharacterEncoding("utf-8");
%>


<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Frank+Ruhl+Libre:wght@400;500;700&family=Gothic+A1:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../css/user_info.css">
    <title>CALENDAR</title>
</head>
<body>
    <header onclick="backLogInEvent()">
        Co.Calendar
    </header>
    <main>
        <form class="signup_box" action="../action/signup_action.jsp" method="POST">
            <div class="input_box">
                <input name="id" type="text" class="input" placeholder="사용할 ID를 입력해주세요." required>
                <button type="button" onclick="idSearchEvent()"><img src="../img/icons8-tiktok-verified-account-64.png" alt="비밀번호 확인"></button>
            </div>
            <div class="input_box">
                <input name="pw" type="password" class="input" placeholder="비밀번호를 입력해주세요." required>
                <button type="button" onclick="showPwEvent(1)"><img src="../img/icons8-명백한-30.png" alt="비밀번호 확인"></button>
            </div>
            <div class="input_box">
                <input type="password" class="input" placeholder="비밀번호를 다시 입력해주세요." onblur="checkPwEvent()" required>
                <button type="button" onclick="showPwEvent(2)"><img src="../img/icons8-명백한-30.png" alt="비밀번호 확인"></button>
            </div>
            <div class="input_box">
                <input name="name" type="text" class="input" placeholder="이름을 입력해주세요." required>
            </div>
            <div class="input_box email">
                <input name="email" type="email" class="input" placeholder="email@email.com" required>
            </div>
            <div class="input_box phone">
                <input name="phone1" type="tel" class="input" placeholder="010" pattern="[0-1]{3}" required>
                <input name="phone2" type="tel" class="input" placeholder="0000" pattern="[0-9]{4}" required>
                <input name="phone3" type="tel" class="input" placeholder="0000" pattern="[0-9]{4}" required>
            </div>
            <div class="input_box">
                <select name="team" class="input">
                    <option value="0">개발팀</option>
                    <option value="1">교육팀</option>
                    <option value="2">마케팅팀</option>
                    <option value="3">기타(관리자전용)</option>
                </select>
            </div>
            <div class="input_box">
                <select name="rank" class="input">
                    <option value="0">사원</option>
                    <option value="1">팀장</option>
                    <option value="2">관리자</option>
                </select>
            </div>
            </div>
            <div class="btn_box">
                <input id='sign_in' type="submit" value="SIGN IN">
            </div>
            <div class="find_info_box">
                <div class="find_info">
                    <a href="find_id.jsp">아이디 찾기</a>
                    <a href="find_pw.jsp">비밀번호 찾기</a>
                </div>
            </div>
        </form>
    </main>
    <footer>copyright ⓒ te_3_3. All rights reserved.</footer>

    <script>
        function backLogInEvent(){
            document.location.href = "../index.jsp"
        }
        
        function showPwEvent(num){
            var input = document.getElementsByClassName('input')[num]
        
            if (input.type == 'password'){
                input.setAttribute('type', 'text')
            }
            else{
                input.setAttribute('type', 'password')
            }
        }
        
        function checkPwEvent(){
            var pw = document.getElementsByClassName('input')[1].value
            var confirm_pw = document.getElementsByClassName('input')[2]
        
            console.log('pwcheck:' , pw, confirm_pw)
        
            if (pw != confirm_pw.value){
                confirm_pw.setCustomValidity("비밀번호가 일치하지 않습니다."); 
                confirm_pw.reportValidity();
            }
            else{
                confirm_pw.setCustomValidity(""); 
            }
        }
        
        // 팝업창 열어서 서버로 id 값 전송
        function idSearchEvent(){
            var id = document.getElementsByClassName('input')[0]
            var idValue = document.getElementsByClassName('input')[0].value

            var title = "아이디 중복확인" ;
		
            window.open("", title, 'width=400, height=300') ;
            
            var form = document.createElement('form')
            var input = document.createElement('input')
            input.type = 'hidden'
            input.name = 'idValue'
            input.value = idValue
            
            form.target = title
            form.action = "../action/id_check_action.jsp"
            form.method = 'POST'
            
            form.appendChild(input)
            document.body.appendChild(form)
            
            form.submit() ;
        }
    </script>
</body>
</html>