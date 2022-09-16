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

    String idValue = request.getParameter("idValue");

    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 

    // SQL문 준비 작업
    String sql = "SELECT id FROM users WHERE id=?";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, idValue);

    ResultSet result = query.executeQuery();

    String dbId = "";
    while(result.next()) {
        dbId = result.getString(1);
    }
    
    String idCheck = "0";
    if (idValue == null || idValue.equals("")){
        idCheck = "0";
    }
    else if (dbId == null || dbId.equals("")){
        idCheck = "1";
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
    <title>ID CHECK</title>
</head>
<body>
    <h2></h2>
    <input type="button" onclick="window.close()" value="확인"></button>

    <script>// 사용할 수 있으면 입력칸 막고 버튼 보여주기
        var idCheck = <%=idCheck%>

        var idInput = opener.document.getElementsByClassName('input')[0]

        if (idCheck == 1){
            document.getElementsByTagName('h2')[0].innerHTML ='사용할 수 있는 아이디입니다!'

            idInput.style.opacity = '0.5'
            idInput.readOnly = true

            opener.document.getElementById('sign_in').style.display = 'block'

        }
        else{
            document.getElementsByTagName('h2')[0].innerHTML ='사용할 수 없는 아이디입니다!'

            idInput.value = ''
        }
    </script>
</body>
</html>