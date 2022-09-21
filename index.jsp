<%@ page language="java" contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<%
    // 이전 페이지로부터 온 값 인코딩 설정
    request.setCharacterEncoding("utf-8");

    String id = "";
    
    id = (String)session.getAttribute("id");

    if (id != null){
        response.sendRedirect("../html/main.jsp");
    }
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
    <link rel="stylesheet" type="text/css" href="css/index.css">
    <title>CALENDAR LOGIN</title>
</head>
<body>
    <header onclick="mainPageEvent()"></header>
    <main>
        <div class="info_box">
            <div class="info_text">
                Co.Calendar
            </div>
            <div class="info">자유롭게 일정을 관리하세요.</div>
        </div>
        <form class="login_box" action="action/login_action.jsp" method="POST">
            <div class="id_box">
                <input name="id" type="text" class="id" placeholder="ID" required>
            </div>
            <div class="pw_box">
                <input name="pw" type="password" class="pw" placeholder="PASSWORD" required>
                <button type="button" onclick="showPwEvent()"><img src="img/icons8-명백한-30.png" alt="비밀번호 확인"></button>
            </div>
            <div class="btn_box">
                <input type="submit" value="LOG IN">
            </div>
            <div class="find_info_box">
                <div class="sign_up">
                    <a href="html/sign_up.jsp">회원가입</a>
                </div>
                <div class="find_info">
                    <a href="html/find_id.jsp">아이디 찾기</a>
                    <a href="html/find_pw.jsp">비밀번호 찾기</a>
                </div>
            </div>
        </form>
    </main>
    <footer>copyright ⓒ te_3_3. All rights reserved.</footer>

    <script src="js/index.js"></script>
</body>
</html>