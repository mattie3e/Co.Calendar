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
