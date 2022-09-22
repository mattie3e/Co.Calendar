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
    request.setCharacterEncoding("utf-8");

    String id = "";

    String dateValue = "";

    id = (String)session.getAttribute("id");

    if (id==null || id.equals("")){
        response.sendRedirect("../index.jsp");
    }
    else{
        String idxValue = request.getParameter("indexValue");
    
        Class.forName("com.mysql.jdbc.Driver");
    
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 
    
        String sql = "DELETE FROM user_plans WHERE idx=?";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, idxValue);
     
        query.executeUpdate();
    
        response.sendRedirect("../html/main.jsp");
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title></title>
</head>
<body>
    <script>
        window.onload = function(){
            var form = document.createElement('form')

            var input = document.createElement('input')
            input.type = 'hidden'
            input.value = '<%=dateValue%>'.slice(0, 10)
            input.name = 'inquireDateValue'
            console.log(input.value)
            form.action = '../html/main.jsp'
            form.appendChild(input)

            document.body.appendChild(form)
            form.submit()
        }
    </script>
</body>
</html>