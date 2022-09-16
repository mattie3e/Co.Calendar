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
    String pwValue = request.getParameter("pw");

    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 

    // SQL문 준비 작업
    String sql = "SELECT id, pw, name FROM users WHERE id=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, idValue);

    ResultSet result = query.executeQuery();

    String id = "";
    String pw = "";
    String name = "";

    while(result.next()) {
        id = result.getString(1);
        pw = result.getString(2);
        name = result.getString(3);
    }
    
    String check = "0";
    if (pw.equals(pwValue)){
        session.setAttribute("name", name);
        session.setAttribute("id", id);
        // response.sendRedirect("../html/main.jsp");
    }
    else if (id == null || id.equals("")){
        check = "1";
    }
    else {
        check = "2";
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
    <title></title>
</head>
<body>
    <script>
        var check = <%=check%>

        if (check == 0) {
            location.href = "../html/main.jsp"
        }
        else if (check == 1){
            alert("등록되지 않은 아이디입니다.")
            console.log("등록되지 않은 아이디입니다.")
            window.history.back()
        }
        else if (check == 2){
            alert("비밀번호가 잘못되었습니다.")
            console.log("비밀번호가 잘못되었습니다.")
            window.history.back()
        }

    </script>
</body>
</html>