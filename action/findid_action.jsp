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

    String nameValue = request.getParameter("name");
    String phoneValue = request.getParameter("phone1") + request.getParameter("phone2") + request.getParameter("phone3");
    String teamValue = request.getParameter("team");
    String rankValue = request.getParameter("rank");

    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 

    String sql = "SELECT id FROM users WHERE name=? AND phone=? AND team=? AND rank=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, nameValue);
    query.setString(2, phoneValue);
    query.setString(3, teamValue);
    query.setString(4, rankValue);

    ResultSet result = query.executeQuery();

    String id = "";

    while(result.next()) {
        id = result.getString(1);
    }
    
    String check = "0";
    if (id == null || id.equals("")){
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
    <title></title>
</head>
<body>
    <script>
        var check = <%=check%>

        if (check == 1){
            alert("아이디를 찾을 수 없습니다. 입력한 정보를 확인해주세요.")
            window.history.back()
        }
        else if (check == 0){
            alert("아이디는 " + "<%=id%>" + "입니다.")
            document.location.href = "../index.jsp"
        }

    </script>
</body>
</html>