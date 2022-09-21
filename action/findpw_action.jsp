<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.time.LocalDateTime"%>
<%@ page import="java.time.ZoneId"%>
<%@ page import="java.time.format.DateTimeFormatter"%>

<%
    // 이전 페이지로부터 온 값 인코딩 설정
    request.setCharacterEncoding("utf-8");

    String idValue = request.getParameter("id");
    String nameValue = request.getParameter("name");
    String phoneValue = request.getParameter("phone1") + request.getParameter("phone2") + request.getParameter("phone3");

    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 

    // SQL문 준비 작업
    String sql = "SELECT pw FROM users WHERE id=? AND name=? AND phone=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, idValue);
    query.setString(2, nameValue);
    query.setString(3, phoneValue);

    ResultSet result = query.executeQuery();

    String pw = "";

    while(result.next()) {
        pw = result.getString(1);
    }
    
    String check = "0";
    if (pw == null || pw.equals("")){
        check = "1";
    }

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Frank+Ruhl+Libre:wght@400;500;700&family=Gothic+A1:wght@300;400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="../css/id_check.css">
    <title>비밀번호 찾기</title>
</head>
<body>
    <h2></h2>
    <input type="button" onclick="window.close()" value="확인"></button>

    <script>// 사용할 수 있으면 입력칸 막고 버튼 보여주기
        var check = <%=check%>

        if (check == 1){
            document.getElementsByTagName('h2')[0].innerHTML = "비밀번호를 찾을 수 없습니다. 입력한 정보를 확인해주세요."
        }
        else if (check == 0){
            document.getElementsByTagName('h2')[0].innerHTML = "비밀번호는 " + "<%=pw%>" + "입니다."
        }
    </script>
</body>
</html>