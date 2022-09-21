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

    id = (String)session.getAttribute("id");

    if (id==null || id.equals("")){
        response.sendRedirect("../index.jsp");
    }
    else{
        LocalDateTime dateTime = LocalDateTime.now(ZoneId.of("Asia/Seoul"));
        String writeDate = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(dateTime);
        String dateValue = request.getParameter("planDate");
        String textValue = request.getParameter("planValue");
    
        Class.forName("com.mysql.jdbc.Driver");
    
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 
    
        String sql = "INSERT INTO user_plans (writer, user_plan, plan_date, write_date) VALUES (?, ?, ?, ?)";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, id);
        query.setString(2, textValue);
        query.setString(3, dateValue);
        query.setString(4, writeDate);
     
        query.executeUpdate();
    
        response.sendRedirect("../html/main.jsp");
    }
%>
