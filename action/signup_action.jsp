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

    // 가입날짜로 현재날짜, 시간 받아오기
    LocalDateTime dateTime = LocalDateTime.now(ZoneId.of("Asia/Seoul"));
    String joinDate = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss").format(dateTime);

    // 이전 페이지로부터 값 받아오는 부분
    String idValue = request.getParameter("id");
    String pwValue = request.getParameter("pw");
    String nameValue = request.getParameter("name");
    String emailValue = request.getParameter("email");
    String phoneValue = request.getParameter("phone1") + request.getParameter("phone2") + request.getParameter("phone3");
    String teamValue = request.getParameter("team");
    String rankValue = request.getParameter("rank");

    Class.forName("com.mysql.jdbc.Driver");  // 커넥터를 불러오는 명령어 줄

    // DB 주소, 계정 아이디, 비밀번호 적어주기 mysql포트는 3306 : DB 연결 작업
    Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 

    // SQL문 준비 작업
    String sql = "INSERT INTO users (id, pw, name, email, phone, team, rank, join_date) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    PreparedStatement query = connect.prepareStatement(sql);
    query.setString(1, idValue);
    query.setString(2, pwValue);
    query.setString(3, nameValue);
    query.setString(4, emailValue);
    query.setString(5, phoneValue);
    query.setString(6, teamValue);
    query.setString(7, rankValue);
    query.setString(8, joinDate);

    query.executeUpdate();
    // 값 업데이트 삽입 삭제
%>

<head>
    <title></title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body>
    <script>
        document.location.href = '../index.jsp'
    </script>

</body>