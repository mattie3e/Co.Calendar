<%@ page language="java" contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>

<%
    // 이전 페이지로부터 온 값 인코딩 설정
    request.setCharacterEncoding("utf-8");

    String name = "";
    String check = "0";
    String id = "";
    name = (String)session.getAttribute("name");
    id = (String)session.getAttribute("id");

    if (name==null || name.equals("")){
        check = "1";
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
    <link rel="stylesheet" type="text/css" href="../css/main.css">
    <title>CALENDAR</title>
</head>
<body>
    <header>
        <button type="button" class="menu_icon" onclick="showMenuEvent()">
            <img src="../img/icons8-menu-30.png" alt="">
        </button>
        <div class="user"><span>🤨</span><%=name%></div>

        <button class="pre" onclick="changeMonthEvent('down')">◀</button>
        <div class="year"></div>
        <div class="year">년&nbsp</div>
        <div class="month"></div>
        <div class="month">월</div>
        <button class="next" onclick="changeMonthEvent('up')">▶</button>
        
        <button type="button" class="add_btn" onclick="showAddEvent()">🖋️</button>
        <div class="log_out" onclick="logOutEvent()">LOG OUT</div>
    </header>
    <nav>
        <div class="staff_box">
            <div class="team">개발팀</div>
            <li class="staff">안태현 <div class="rank">사원</div></li>
            <li class="staff">김재연 <div class="rank">팀장</div></li>
            <li class="staff">이민영 <div class="rank">관리자</div></li>
            <li class="staff">김성언 <div class="rank">팀장</div></li>
        </div>
        <!-- <div class="staff_box">
            <div class="team">교육팀</div>
            <li class="staff">안태현 <div class="rank">사원</div></li>
            <li class="staff">김재연 <div class="rank">사원</div></li>
            <li class="staff">이민영 <div class="rank">사원</div></li>
            <li class="staff">김성언 <div class="rank">사원</div></li>
        </div>
        <div class="staff_box">
            <div class="team">마케팅팀</div>
            <li class="staff">안태현 <div class="rank">사원</div></li>
            <li class="staff">김재연 <div class="rank">사원</div></li>
            <li class="staff">이민영 <div class="rank">사원</div></li>
            <li class="staff">김성언 <div class="rank">사원</div></li>
        </div> -->
    </nav>

    <!-- 메인 -->
    <main>
        <div class="add">
            <input id="date" type="datetime-local">
            <input type="text" id="add_input" placeholder="일정을 입력해주세요">
            <button type="button" onclick="addEvent()" class="add_input_btn">➕</button>
        </div>
        <div class="plan">
            <div class="date">11일</div>
            <li><time datetime="00:00">오전 12시</time> 
                <div class="date_plan">추석연휴ㅁㄴㅁㅇㄹㅁㄴㄹㄴㅁㄹㅁㄴㄹㅇㄴㅁㄹㅁㄴㄹㄴㅁㅇㄹㄴㄹ</div>
                <button type="button" class="modify_btn" onclick="modifyEvent()">🖋️</button>
                <button type="button" class="delete_btn" onclick="deleteEvent()">🗑️</button>
            </li>
            <li><time datetime="08:00">오전 8시</time> 
                <div class="date_plan">기상</div>
                <button type="button" class="modify_btn" onclick="modifyEvent()">🖋️</button>
                <button type="button" class="delete_btn" onclick="deleteEvent()">🗑️</button>
             </li>

            <div class="date">20일</div>
            <li><time datetime="09:00">오전 9시</time> 
                <div class="date_plan">디지털 신호처리</div> 
                <button type="button" class="modify_btn" onclick="modifyEvent()">🖋️</button>
                <button type="button" class="delete_btn" onclick="deleteEvent()">🗑️</button>
            </li>

            <li><time datetime="15:00">오후 3시</time> 
                <div class="date_plan">중국어</div> 
                <button type="button" class="modify_btn" onclick="modifyEvent()">🖋️</button>
                <button type="button" class="delete_btn" onclick="deleteEvent()">🗑️</button>
            </li>
        </div>
    </main>

    <script>
        function showMenuEvent(){
            var nav = document.getElementsByTagName('nav')[0]
        
            console.log(nav.style.opacity)
            if (nav.style.opacity == '1'){
                nav.style.visibility = 'hidden'
                nav.style.opacity = '0'
            }
            else{
                nav.style.visibility = 'visible'
                nav.style.opacity = '1'
            }
        }
        
        function showAddEvent(){
            var add = document.getElementsByClassName('add')[0]
        
            console.log(add.style.visibility)
            if (add.style.visibility == 'visible'){
                add.style.visibility = 'hidden'
            }
            else{
                add.style.visibility = 'visible'
            }
        }

        function addEvent(){
            var value = document.getElementById('add_input').value

            var li = document.createElement('li')
            var div = document.createElement('div')
            div.className = 'date_plan'
            div.innerHTML = value

            var modifyBtn = document.createElement('button')
            modifyBtn.className = 'modify_btn'
            modifyBtn.addEventListener('click', modifyEvent)
            modifyBtn.innerHTML = '🖋️'

            var deleteBtn = document.createElement('button')
            deleteBtn.className = 'delete_btn'
            deleteBtn.addEventListener('click', deleteEvent)
            deleteBtn.innerHTML = '🗑️'
        }
        
        function modifyEvent(){
            const target = event.target        
            const textTag = target.previousElementSibling
            const value = textTag.innerHTML

            var modify = document.createElement('input')
            modify.type = 'text'
            modify.value = value
            modify.className = 'modify_input'
            modify.style.width = '100%'
            modify.addEventListener('keydown', function(event) {
                if (event.keyCode === 13) {
                  event.preventDefault()
                  modify_complete(modify.value, value, textTag, modify, completeBtn, cancelBtn, target, delBtn)
                }
              })
  
            
            textTag.innerHTML = ''
            textTag.appendChild(modify)

            var completeBtn = document.createElement('button')
            completeBtn.type = 'button'
            completeBtn.innerHTML = '✅'
            completeBtn.className = 'modify_input_btn'

            var cancelBtn = document.createElement('button')
            cancelBtn.type = 'button'
            cancelBtn.innerHTML = '❎'
            cancelBtn.className = 'modify_input_btn'

            textTag.after(cancelBtn)
            textTag.after(completeBtn)

            var delBtn = target.nextElementSibling
            target.style.visibility = 'hidden'
            delBtn.style.visibility = 'hidden'

            completeBtn.addEventListener('click', function(){modify_complete(modify.value, value, textTag, modify, completeBtn, cancelBtn, target, delBtn)})
            cancelBtn.addEventListener('click', function(){modify_cancel(value, textTag, modify, completeBtn, cancelBtn, target, delBtn)})
        }

        function modify_complete(value, oriValue, oriTag, input, completeBtn, cancelBtn, modifyBtn, delBtn){
            if (value == oriValue || value == ''){
                modify_cancel(oriValue, oriTag, input, completeBtn, cancelBtn, modifyBtn, delBtn)
            }
            else{
                var confirmValue = confirm("수정하시겠습니까?")

                if (confirmValue == true){
                    input.remove()
                    completeBtn.remove()
                    cancelBtn.remove()
                    oriTag.innerHTML = value

                    modifyBtn.style.removeProperty("visibility")
                    delBtn.style.removeProperty("visibility")
                }
            }
        }

        function modify_cancel(oriValue, oriTag, input, completeBtn, cancelBtn, modifyBtn, delBtn){
            input.remove()
            completeBtn.remove()
            cancelBtn.remove()
            oriTag.innerHTML = oriValue

            modifyBtn.style.removeProperty("visibility")
            delBtn.style.removeProperty("visibility")
        }

        function deleteEvent(){
            var confirmValue = confirm("삭제하시겠습니까?")

            if (confirmValue == true){
                event.target.parentElement.remove()
            }
        }
        
        function logOutEvent(){
            <%
                session.invalidate();
                //response.sendRedirect("../index.jsp");
                //왜 위에껄로 하면 버튼 안눌러도 로그아웃댐???? 새로고침하면 왜 로그아웃댐?????
            %>
            document.location.href = '../index.jsp'
        }

        function changeDateEvent(yearValue, monthValue){
            var month = document.getElementsByClassName('month')[0]
            var year = document.getElementsByClassName('year')[0]

            year.innerHTML = yearValue
            month.innerHTML = monthValue
        }

        function changeMonthEvent(updown){
            var month = document.getElementsByClassName('month')[0].innerHTML
            var year = document.getElementsByClassName('year')[0].innerHTML

            if (updown == 'up'){
                month = parseInt(month) + 1
                if (month == 13){ 
                    changeDateEvent(parseInt(year) + 1, 1)
                }
                else{
                    changeDateEvent(year, month)
                }
            }
            else if (updown == 'down'){
                month = parseInt(month) - 1
                if (month == 0){ 
                    changeDateEvent(parseInt(year) - 1, 12)
                }
                else{
                    changeDateEvent(year, month)
                }
            }
        }

        window.onload = function(){
            console.log("<%=name%>")
            console.log("<%=id%>")

            if (<%=check%> == 1){
                //document.location.href = '../index.jsp'
            }

            document.getElementsByClassName('log_out')[0].addEventListener('click', logOutEvent)


            // 오늘 날짜로 input 기본값 세팅
            const offset = new Date().getTimezoneOffset() * 60000;
            const today = new Date(Date.now() - offset);
            document.getElementById('date').value = today.toISOString().slice(0, 16)

            changeDateEvent(today.getFullYear(), today.getMonth())
        }
    </script>
</body>
</html>