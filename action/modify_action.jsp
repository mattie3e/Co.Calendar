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
        String modifyDate = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(dateTime);
        String idxValue = request.getParameter("indexValue");
        String textValue = request.getParameter("textValue");

    
        Class.forName("com.mysql.jdbc.Driver");
    
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 
    
        String sql = "UPDATE user_plans SET user_plan=?, modify_date=? WHERE idx=?";
        PreparedStatement query = connect.prepareStatement(sql);
        query.setString(1, textValue);
        query.setString(2, modifyDate);
        query.setString(3, idxValue);
     
        query.executeUpdate();
    
        response.sendRedirect("../html/main.jsp");
    }
%>
