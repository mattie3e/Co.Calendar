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
        <form class="signup_box" action="../action/findpw_action.jsp" method="POST">
            <div class="input_box">
                <input name="id" type="text" class="input" placeholder="아이디를 입력해주세요" required>
            </div>
            <div class="input_box">
                <input name="name" type="text" class="input" placeholder="이름을 입력해주세요" required>
            </div>
            <div class="input_box phone">
                <input name="phone1" type="tel" class="input" placeholder="010" pattern="[0-1]{3}" required>
                <input name="phone2" type="tel" class="input" placeholder="0000" pattern="[0-9]{4}" required>
                <input name="phone3" type="tel" class="input" placeholder="0000" pattern="[0-9]{4}" required>
            </div>
            <div class="btn_box">
                <input type="submit" value="FIND PW">
            </div>
            <div class="find_info_box">
                <div class="sign_up">
                    <a href="sign_up.jsp">회원가입</a>
                </div>
            </div>
        </form>
    </main>
    <footer>copyright ⓒ te_3_3. All rights reserved.</footer>

    <script src="../js/sign_up.js"></script>
</body>
</html>