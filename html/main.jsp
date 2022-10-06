<%@ page language="java" contentType="text/html" pageEncoding="utf-8"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.time.LocalDateTime"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.ZoneId"%>
<%@ page import="java.time.format.DateTimeFormatter"%>


<%
    // 이전 페이지로부터 온 값 인코딩 설정
    request.setCharacterEncoding("utf-8");

    String check = "0";

    String name = "";
    String id = "";
    String rank = "";
    String team = "";

    name = (String)session.getAttribute("name");
    id = (String)session.getAttribute("id");
    rank = (String)session.getAttribute("rank");
    team = (String)session.getAttribute("team");

    String currentMonth = "";
    String nextMonth = "";
    String writer = "";

    ArrayList<String> teamData = new ArrayList<String>();

    ArrayList<String> devTeamData = new ArrayList<String>();
    ArrayList<String> eduTeamData = new ArrayList<String>();
    ArrayList<String> mkTeamData = new ArrayList<String>();
    ArrayList<String> mngTeamData = new ArrayList<String>();

    // 일정 저장 배열
    ArrayList<String> data = new ArrayList<String>();

    ///////////////// 세션 //////////////////////

    if (name==null || name.equals("")){
        response.sendRedirect("../index.jsp");
    }
    else{


        ///////////////// 팀원 조회 ////////////////////// 

        Class.forName("com.mysql.jdbc.Driver");  // 커넥터를 불러오는 명령어 줄

        // DB 주소, 계정 아이디, 비밀번호 적어주기 mysql포트는 3306 : DB 연결 작업
        Connection connect = DriverManager.getConnection("jdbc:mysql://localhost:3306/calendar", "tae", "1031"); 

        ///// 관리자 전용 //////
        if (rank.equals("관리자")){
            String sql = "SELECT name, rank, team, idx FROM users WHERE id NOT IN (?) ORDER BY team ASC, rank DESC";
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1, id);

            ResultSet result = query.executeQuery();
        
            while(result.next()) {
                if (result.getString(3).equals("개발팀")){
                    devTeamData.add("[" + "'" + result.getString(1) + "'" + "," + "'" + result.getString(2) + "'" + "," + "'" + result.getString(3) + "'" + "," + "'" + result.getString(4) + "'" + "]");
                }
                else if (result.getString(3).equals("교육팀")){
                    eduTeamData.add("[" + "'" + result.getString(1) + "'" + "," + "'" + result.getString(2) + "'" + "," + "'" + result.getString(3) + "'" + "," + "'" + result.getString(4) + "'" + "]");
                }
                else if (result.getString(3).equals("마케팅팀")){
                    mkTeamData.add("[" + "'" + result.getString(1) + "'" + "," + "'" + result.getString(2) + "'" + "," + "'" + result.getString(3) + "'" + "," + "'" + result.getString(4) + "'" + "]");
                }
                else{
                    mngTeamData.add("[" + "'" + result.getString(1) + "'" + "," + "'" + result.getString(2) + "'" + "," + "'" + result.getString(3) + "'" + "," + "'" + result.getString(4) + "'" + "]");
                } 
            }
        }
        else{
            ///// 그외 //////
            String sql = "SELECT name, rank, team, idx FROM users WHERE team=? AND id NOT IN (?) ORDER BY team ASC, rank DESC";
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1, team);
            query.setString(2, id);

            // SQL문 전송 및 결과 받기
            ResultSet result = query.executeQuery();
        
            while(result.next()) { 
                teamData.add("[" +  "'" + result.getString(1) + "'" + "," + "'" + result.getString(2) + "'" + "," + "'" + result.getString(3) + "'" + "," + "'" + result.getString(4) + "'" + "]");
            }
        }


        ///////////////// 일정 조회 //////////////////////
        currentMonth = request.getParameter("inquireDateValue");
        writer = id;


        if (currentMonth == null || currentMonth.equals("")){
            LocalDateTime dateTime = LocalDateTime.now(ZoneId.of("Asia/Seoul"));

            currentMonth = dateTime.withDayOfMonth(1).format(DateTimeFormatter.ISO_DATE);
            nextMonth = dateTime.plusMonths(1).withDayOfMonth(1).minusDays(1).format(DateTimeFormatter.ISO_DATE) + " 23:59:59";

            String sql = "SELECT user_plan, plan_date, idx FROM user_plans WHERE plan_date BETWEEN ? AND ? AND writer=? ORDER BY plan_date ASC";
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1, currentMonth);
            query.setString(2, nextMonth);
            query.setString(3, writer);
    
            // SQL문 전송 및 결과 받기
            ResultSet result = query.executeQuery();
    
            // result.next 읽어온 테이블에서 읽을 수 있는 다음 줄이 있을때까지 계속 읽기
            while(result.next()) {
                data.add("[" + "'" + result.getString(1) + "'" + "," + "'" + result.getString(2) + "'" + "," + "'" + result.getString(3) + "'" + "]");
            }
        }
        else{
            String[] tmp = currentMonth.split("-");

            currentMonth = tmp[0] + "-" + tmp[1] + "-" + "01";

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");         
            LocalDate dateTime = LocalDate.parse(currentMonth, formatter);
            nextMonth = dateTime.plusMonths(1).withDayOfMonth(1).minusDays(1).format(DateTimeFormatter.ISO_DATE) + " 23:59:59";


            String sql = "SELECT user_plan, plan_date, idx FROM user_plans WHERE plan_date BETWEEN ? AND ? AND writer=? ORDER BY plan_date ASC";
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1, currentMonth);
            query.setString(2, nextMonth);
            query.setString(3, writer);
    
            // SQL문 전송 및 결과 받기
            ResultSet result = query.executeQuery();
    
            // result.next 읽어온 테이블에서 읽을 수 있는 다음 줄이 있을때까지 계속 읽기
            while(result.next()) {
                data.add("[" + "'" + result.getString(1) + "'" + "," + "'" + result.getString(2) + "'" + "," + "'" + result.getString(3) + "'" + "]");
            }
        }
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
        <div class="header_item">
            <button type="button" class="menu_icon" onclick="showMenuEvent()">
                <img src="../img/icons8-menu-30.png" alt="">
            </button>
            <div class="user" onclick="backToMainEvent()"><span>🤨</span><%=name%></div>
        </div>
        <div class="header_item">
            <button class="pre" onclick="changeMonthEvent('down')">◀</button>
            <div class="year"></div>
            <div class="year right_space">년</div>
            <div class="month"></div>
            <div class="month">월</div>
            <button class="next" onclick="changeMonthEvent('up')">▶</button>
        </div>
        <div class="header_item">
            <button type="button" class="add_btn" onclick="showAddEvent()">🖋️</button>
            <div class="log_out" onclick="logOutEvent()">LOG OUT</div>
        </div>
    </header>
    <nav>
        <div class="nav_icon_box">
            <button type="button" class="menu_icon" onclick="showMenuEvent()">
                <img src="../img/icons8-menu-30.png" alt="">
            </button>
            <div class="user" onclick="backToMainEvent()"><span>🤨</span><%=name%></div>
            <span class="nav_rank"><%=rank%></span>
        </div>
        <!-- <div class="staff_box">
            <div class="team">개발팀</div>
            <li class="staff">안태현 <div class="rank">사원</div></li>
            <li class="staff">김재연 <div class="rank">팀장</div></li>
            <li class="staff">이민영 <div class="rank">관리자</div></li>
            <li class="staff">김성언 <div class="rank">팀장</div></li>
        </div> -->
        <!-- <div class="staff_box">
            <div class="team">교육팀</div>
            <li class="staff">안태현 <div class="rank">사원</div></li>
            <li class="staff">김재연 <div class="rank">사원</div></li>
            <li class="staff">이민영 <div class="rank">사원</div></li>
            <li class="staff">김성언 <div class="rank">사원</div></li>
        </div> -->
    </nav>
    <div id="block_box" onclick="showMenuEvent()"></div>

    <!-- 메인 -->
    <main>
        <form class="add" action="../action/save_plan_action.jsp">
            <input id="date" name="planDate" type="date">
            <input type="text" id="add_input" name="planValue" placeholder="일정을 입력해주세요" required>
            <button type="submit" class="add_input_btn">➕</button>
        </form>
        <div class="plan">
            <!-- <div class="date">11일</div>
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
            </li> -->
        </div>
    </main>

    <script>
        function showMenuEvent(){
            var nav = document.getElementsByTagName('nav')[0]
            var blockBox = document.getElementById('block_box')
            
            if (nav.style.opacity == '1'){
                nav.style.visibility = 'hidden'
                nav.style.opacity = '0'
                blockBox.style.visibility = 'hidden'
                blockBox.style.opacity = '0'
            }
            else{
                nav.style.visibility = 'visible'
                nav.style.opacity = '1'
                blockBox.style.visibility = 'visible'
                blockBox.style.opacity = '0.3'
            }
        }
        
        function showAddEvent(){
            var add = document.getElementsByClassName('add')[0]
    
            if (add.style.display == 'flex'){
                add.style.display = 'none'
            }
            else{
                add.style.display = 'flex'
            }
        }
        
        ///////// 수정 삭제 관련 함수 ////////
        function modifyEvent(){
            const target = event.target        
            const textTag = target.previousElementSibling
            const value = textTag.innerHTML

            var modify = document.createElement('input')
            modify.type = 'text'
            modify.value = value
            modify.className = 'modify_input'
            modify.addEventListener('keydown', function(event) {
                if (event.keyCode === 13) {
                  event.preventDefault()
                  modifyCompleteEvent(modify.value, value, textTag, modify, completeBtn, cancelBtn, target, delBtn)
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

            completeBtn.addEventListener('click', function(){modifyCompleteEvent(modify.value, value, textTag, modify, completeBtn, cancelBtn, target, delBtn)})
            cancelBtn.addEventListener('click', function(){modifyCancelEvent(value, textTag, modify, completeBtn, cancelBtn, target, delBtn)})
        }

        function modifyCompleteEvent(value, oriValue, oriTag, input, completeBtn, cancelBtn, modifyBtn, delBtn){
            if (value == oriValue || value == ''){
                modifyCancelEvent(oriValue, oriTag, input, completeBtn, cancelBtn, modifyBtn, delBtn)
            }
            else{
                var confirmValue = confirm("수정하시겠습니까?")

                if (confirmValue == true){
                    var form = document.createElement('form')

                    var index = document.createElement('input')
                    index.type = 'hidden'
                    index.value = modifyBtn.id
                    index.name = 'indexValue'
                    
                    var text = document.createElement('input')
                    text.type = 'hidden'
                    text.value = value
                    text.name = 'textValue'

                    var date = document.createElement('input')
                    date.type = 'hidden'
                    date.value = '<%=currentMonth%>'
                    date.name = 'inquireDateValue'
                    
                    form.appendChild(index)
                    form.appendChild(text)
                    form.appendChild(date)  
                    form.method = 'POST'
                    form.action = '../action/modify_action.jsp'
                    
                    document.body.appendChild(form)
                    form.submit()
                }
            }
        }

        function modifyCancelEvent(oriValue, oriTag, input, completeBtn, cancelBtn, modifyBtn, delBtn){
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
                var form = document.createElement('form')

                var index = document.createElement('input')
                index.type = 'hidden'
                index.value = event.target.id
                index.name = 'indexValue'
                
                var date = document.createElement('input')
                date.type = 'hidden'
                date.value = '<%=currentMonth%>'
                date.name = 'inquireDateValue'
                

                form.appendChild(date)  
                form.appendChild(index)
                form.method = 'POST'
                form.action = '../action/delete_action.jsp'
                
                document.body.appendChild(form)
                form.submit()
            }
        }


        //////// 월 변경 관련 함수 ////////
        function changeDateEvent(yearValue, monthValue){ // set 하고 event 빼기
            var month = document.getElementsByClassName('month')[0]
            var year = document.getElementsByClassName('year')[0]

            year.innerHTML = yearValue
            month.innerHTML = monthValue
        }

        function monthSubmitEvent(year, month){ // 얘도 event 빼기
            console.log(month)
            if (String(month).length == 1){
                month = '0' + month
            }
            var date = year + '-' + month + '-' + '01'

            var form = document.createElement('form')

            var input = document.createElement('input')
            input.type = 'hidden'
            input.value = date
            input.name = 'inquireDateValue'

            form.action = 'main.jsp'
            form.method = 'POST'
            form.appendChild(input)

            document.body.appendChild(form)
            form.submit()
        }

        function changeMonthEvent(updown){
            var month = document.getElementsByClassName('month')[0].innerHTML
            var year = document.getElementsByClassName('year')[0].innerHTML

            if (updown == 'up'){
                month = parseInt(month) + 1
                if (month == 13){ 
                    monthSubmitEvent(parseInt(year) + 1, 1)
                }
                else{
                    monthSubmitEvent(year, month)
                }
            }
            else if (updown == 'down'){
                month = parseInt(month) - 1
                if (month == 0){ 
                    monthSubmitEvent(parseInt(year) - 1, 12)
                }
                else{
                    monthSubmitEvent(year, month)
                }
            }
        }

        function logOutEvent(){
                //session.invalidate();
                //response.sendRedirect("../index.jsp");
                //왜 위에껄로 하면 버튼 안눌러도 로그아웃댐???? 새로고침하면 왜 로그아웃댐?????
                // if문을 안써줬다~~
            document.location.href = '../action/logout_action.jsp'
        }

        //////// 다른 직원 조회 ////////
        function viewStaffPlanEvent(rank){
            const myRank = '<%=rank%>'
            if (myRank == '관리자' || myRank == '팀장'){
                var form = document.createElement('form')
                var idx = document.createElement('input')
                idx.type = 'hidden'
                idx.name = 'idx'
                idx.value = event.target.id

                form.appendChild(idx)
                form.method = 'POST'
                form.action = 'view_main.jsp'

                document.body.appendChild(form)
                form.submit()
            }
            else{
                alert('접근권한이 없습니다.')
            }
        }

        function makeStaffBox(tmpData){
            var teamData = tmpData

            var staffBox = document.createElement('div')
            staffBox.className = 'staff_box'

            var team = document.createElement('div')
            team.className = 'team'
            team.innerHTML = teamData[0][2]

            staffBox.appendChild(team)

            for (var item of teamData){
                var staff = document.createElement('li')
                staff.className = 'staff'
                staff.innerHTML = item[0]
                staff.id = item[3]

                var rank = document.createElement('div')
                rank.className = 'rank'
                rank.innerHTML = item[1]

                const clickRank = item[1]
                staff.addEventListener('click', function(){
                    viewStaffPlanEvent(clickRank)
                })

                staff.appendChild(rank)
                staffBox.appendChild(staff)
            }

            document.getElementsByTagName('nav')[0].appendChild(staffBox)
        }

        function backToMainEvent(){
            document.location.href = 'main.jsp'
            //document.location.href = 'view_main.jsp'
        }

        function setDefaultInput(){
            const offset = new Date().getTimezoneOffset() * 60000;
            const today = new Date(Date.now() - offset);
            const todayString = today.toISOString()

            var selectDate = document.getElementById('date')
            selectDate.value = todayString.slice(0, 10)

            makeTimeSelector(selectDate)    /////////////////// 생성하면서 Element 전달
        }

        function makeTimeSelector(selectDate){
            //// 오전 오후 ////
            var amPm = document.createElement('select')
            amPm.name = 'amPm'

            var am = document.createElement('option')
            am.value = '오전'
            am.innerHTML = '오전'

            var pm = document.createElement('option')
            pm.value = '오후'
            pm.innerHTML = '오후'

            amPm.appendChild(am)
            amPm.appendChild(pm)

            selectDate.after(amPm)

            //// 시간 1 ~ 12 ////
            var selectHour = document.createElement('select')
            selectHour.name = 'hour'

            for (var i = 1; i <= 12; i++){
                var hour = document.createElement('option')
                hour.value = i
                hour.innerHTML = i + '시'

                selectHour.appendChild(hour)
            }

            amPm.after(selectHour)

            //// 분 00 ~ 59 ////
            var selectMin = document.createElement('select')
            selectMin.name = 'min'

            for (var i = 0; i < 60;){
                var min = document.createElement('option')

                min.value = i
                min.innerHTML = i + '분'
                i += 15

                selectMin.appendChild(min)
            }

            selectHour.after(selectMin)
        }

        function makePlanBox(Data){
            var data = Data
            
            if (data.length == 0){
                var date = document.createElement('div')
                date.className = 'date'
                date.innerHTML = '저장된 일정이 없습니다.'

                document.getElementsByClassName('plan')[0].appendChild(date)
            }

            // 오늘 날짜
            const offset = new Date().getTimezoneOffset() * 60000;
            const today = new Date(Date.now() - offset);
            const todayString = today.toISOString()

            const todayDate = todayString.slice(8, 10)

            const intTodayDay = parseInt(todayDate)
            const intTodayYear = parseInt(todayString.slice(0, 5))
            const intTodayMonth = parseInt(todayString.slice(5, 8))
            const intTodayHour = parseInt(todayString.slice(11, 13))
            const intTodayMin = parseInt(todayString.slice(14, 16))


            //// 날짜칸 생성
            const tmpData = []
            for (var item of data){
                tmpData.push(item[1].slice(8, 10))
            }
            const set = new Set(tmpData)
            console.log(set)

            const DateArray = [...set]
            console.log(DateArray)

            for (var item of DateArray){
                var date = document.createElement('div')
                date.className = 'date'
                date.innerHTML = item + '일'
                if (item == todayDate){
                    date.className += ' today'
                }

                document.getElementsByClassName('plan')[0].appendChild(date)
            }

            for (var item of data){
                var day = item[1].slice(8, 10)
                var date = document.getElementsByClassName('date')

                // 내부 일정칸 생성
                var li = document.createElement('li')
                var time = document.createElement('time')

                var timeValue = item[1].slice(11, 16)
                time.datetime = timeValue 
                
                var intDay = parseInt(day)
                var intYear = parseInt(item[1].slice(0,5))
                var intMonth = parseInt(item[1].slice(5,8))
                var intHour = parseInt(timeValue.slice(0,2))
                var intMin = parseInt(timeValue.slice(3,5))

                console.log(intYear, intMonth)
                console.log(intTodayYear, intTodayMonth)

                if (intHour > 12){
                    time.innerHTML = '오후 ' + (intHour -12) + '시 '
                }
                else if (intHour == 12){
                    time.innerHTML = '오후 ' + intHour + '시 '
                }
                else if (intHour == 0){
                    time.innerHTML = '오전 12시 '
                }
                else{
                    time.innerHTML = '오전 ' + intHour + '시 '
                }

                if (intMin != 0){
                    time.innerHTML += intMin + '분'
                }

                var planName = document.createElement('div')
                planName.className = 'date_plan'
                planName.innerHTML = item[0]

                console.log(item[0])
                /////// 취소선 추가 ///////
                console.log(intDay)
                console.log(intTodayDay)
                if (intYear <= intTodayYear && intMonth < intTodayMonth){
                    planName.className += ' past_plan'
                }
                else if (intYear == intTodayYear && intMonth == intTodayMonth && intDay < intTodayDay){
                    planName.className += ' past_plan'   
                }
                else if (intDay == intTodayDay && intHour <= intTodayHour && intMin <= intTodayMin){
                    planName.className += ' past_plan'
                }

                var modifybutton = document.createElement('button')
                modifybutton.className = 'modify_btn'
                modifybutton.innerHTML = '🖋️'
                modifybutton.id = item[2]
                modifybutton.type = 'button'
                modifybutton.addEventListener('click', modifyEvent)

                var delbutton = document.createElement('button')
                delbutton.className = 'delete_btn'
                delbutton.innerHTML = '🗑️'
                delbutton.id = item[2]
                delbutton.type = 'button'
                delbutton.addEventListener('click', deleteEvent)

                li.appendChild(time)
                li.appendChild(planName)
                li.appendChild(modifybutton)
                li.appendChild(delbutton)

                for (var dateDiv of date){
                    if (dateDiv.innerText.split('\n')[0].slice(0, -1) == day){
                        dateDiv.appendChild(li)
                    }
                }
            }
        }

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        window.onload = function(){
            console.log(<%=data%>)
            console.log("<%=currentMonth%>")
            console.log("<%=nextMonth%>")

            ///////// user margin 등록 ////////
            var width = document.getElementsByClassName('add_btn')[0].offsetWidth - 10;
            document.getElementsByClassName('pre')[0].style.marginLeft = width + 'px';


            ///////// logOutEvent 등록 ////////
            document.getElementsByClassName('log_out')[0].addEventListener('click', logOutEvent)


            ////////// 오늘 날짜로 input 기본값 세팅 ////////
            setDefaultInput()
            

            //////// time select box 만들기 ////////
            //makeTimeSelector() //setDefaultInput()에서 호출함


            //////// 헤더 가운데 날짜 변경 //////// DB에서 오는 값으로 변경
            var currentDate = "<%=currentMonth%>".split('-')
            console.log(currentDate)
            changeDateEvent(currentDate[0], currentDate[1])


            //////// nav 팀명, 팀원명 ////////
            /// 관리자 ///
            if ('<%=rank%>' == '관리자'){
                // 팀별로 나누기
                var devTeam = <%=devTeamData%>
                var eduTeam = <%=eduTeamData%>
                var mkTeam = <%=mkTeamData%>
                var mngTeam = <%=mngTeamData%>

                var department = [devTeam, eduTeam, mkTeam, mngTeam]

                for (var item of department){
                    makeStaffBox(item)
                }
            }
            else{
                var teamData = <%=teamData%>
                makeStaffBox(teamData)
            }

            
            //////// 일정, 날짜칸 생성 ////////
            makePlanBox(<%=data%>)
            
            
            //////// 스크롤 오늘 일정으로 ////////
            var offsetElement = document.getElementsByClassName('today')[0]
            var location;
            if (offsetElement){
                location = offsetElement.offsetTop
                document.getElementsByClassName('plan')[0].scrollTop = location - 150
            }
            
        }
    </script>
</body>
</html>