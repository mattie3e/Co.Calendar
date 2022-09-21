<%@ page language="java" contentType="text/html" pageEncoding="utf-8"%>
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
            String sql = "SELECT name, rank, team, idx FROM users WHERE id NOT IN (?) AND rank NOT IN (?) ORDER BY team ASC, rank DESC";
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1, id);
            query.setString(2, rank);

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
            }
        }
        else{
            ///// 그외 //////
            String sql = "SELECT name, rank, team FROM users WHERE team=? AND id NOT IN (?) ORDER BY team ASC, rank DESC";
            PreparedStatement query = connect.prepareStatement(sql);
            query.setString(1, team);
            query.setString(2, id);

            // SQL문 전송 및 결과 받기
            ResultSet result = query.executeQuery();
        
            while(result.next()) { 
                teamData.add("[" +  "'" + result.getString(1) + "'" + "," + "'" + result.getString(2) + "'" + "," + "'" + result.getString(3) + "'" + "]");
            }
        }


        ///////////////// 일정 조회 //////////////////////
        currentMonth = request.getParameter("inquireDateValue");
        writer = id;


        if (currentMonth == null || currentMonth.equals("")){
            LocalDateTime dateTime = LocalDateTime.now(ZoneId.of("Asia/Seoul"));

            currentMonth = dateTime.withDayOfMonth(1).format(DateTimeFormatter.ISO_DATE);
            nextMonth = dateTime.plusMonths(1).withDayOfMonth(1).format(DateTimeFormatter.ISO_DATE);

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

            if (Integer.parseInt(tmp[1]) + 1 == 13){
                tmp[0] = Integer.toString(Integer.parseInt(tmp[0]) + 1);
                tmp[1] = "01";
            }
            else{
                tmp[1] = Integer.toString(Integer.parseInt(tmp[1]) + 1);
            }

            nextMonth = tmp[0] + "-" + tmp[1] + "-" + tmp[2];

    

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
        <button type="button" class="menu_icon" onclick="showMenuEvent()">
            <img src="../img/icons8-menu-30.png" alt="">
        </button>
        <div class="user" onclick="backToMainEvent()"><span>🤨</span><%=name%></div>

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
            <input id="date" name="planDate" type="datetime-local">
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
            modify.style.width = '100%'
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
                    
                    form.appendChild(index)
                    form.appendChild(text)
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
                
                form.appendChild(index)
                form.action = '../action/delete_action.jsp'
                
                document.body.appendChild(form)
                form.submit()
            }
        }

        //////// 다른 직원 조회 ////////
        function viewStaffPlanEvent(){

        }


        //////// 날짜 변경 관련 함수 ////////
        function changeDateEvent(yearValue, monthValue){
            var month = document.getElementsByClassName('month')[0]
            var year = document.getElementsByClassName('year')[0]

            year.innerHTML = yearValue
            month.innerHTML = monthValue
        }

        function monthSubmitEvent(year, month){
            if (String(month).length == 1){
                month = '0' + month
            }
            var date = year + '-' + month + '-' + '01'

            var form = document.createElement('form')
            var input = document.createElement('input')
            input.type = 'hidden'
            input.value = date
            input.name = 'inquireDateValue'

            form.acntion = 'main.jsp'
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
            <%
                //session.invalidate();
                //response.sendRedirect("../index.jsp");
                //왜 위에껄로 하면 버튼 안눌러도 로그아웃댐???? 새로고침하면 왜 로그아웃댐?????
                // if문을 안써줬다~~
            %>
            document.location.href = '../action/logout_action.jsp'
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
                staff.addEventListener('click', viewStaffPlanEvent)

                var rank = document.createElement('div')
                rank.className = 'rank'
                rank.innerHTML = item[1]

                staff.appendChild(rank)
                staffBox.appendChild(staff)
            }

            document.getElementsByTagName('nav')[0].appendChild(staffBox)
        }

        function backToMainEvent(){
            document.location.reload()
            //document.location.href = 'view_main.jsp'
        }

        

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        window.onload = function(){
            console.log(<%=data%>)
            console.log("<%=currentMonth%>")
            console.log("<%=nextMonth%>")

            ///////// logOutEvent 등록 ////////
            document.getElementsByClassName('log_out')[0].addEventListener('click', logOutEvent)


            ////////// 오늘 날짜로 input 기본값 세팅 ////////
            const offset = new Date().getTimezoneOffset() * 60000;
            const today = new Date(Date.now() - offset);
            const todayString = today.toISOString()

            document.getElementById('date').value = todayString.slice(0, 11) + '00:00'

            //////// 헤더 가운데 날짜 변경 //////// DB에서 오는 값으로 변경
            var currentDate = "<%=currentMonth%>".split('-')
            changeDateEvent(currentDate[0], currentDate[1])


            //////// nav 팀명, 팀원명 ////////
            /// 관리자 ///
            if ('<%=rank%>' == '관리자'){
                // 팀별로 나누기
                var devTeam = <%=devTeamData%>
                var eduTeam = <%=eduTeamData%>
                var mkTeam = <%=mkTeamData%>

                var department = [devTeam, eduTeam, mkTeam]

                for (var item of department){
                    makeStaffBox(item)
                }
            }
            else{
                var teamData = <%=teamData%>
                makeStaffBox(teamData)
            }

            
            //////// 일정, 날짜칸 생성 ////////
            var data = <%=data%>
    
            const todayDate = todayString.slice(8, 10)
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
                
                var intHour = parseInt(timeValue.slice(0,2))
                var intMin = parseInt(timeValue.slice(3,5))

                if (intHour > 12){
                    time.innerHTML = '오후 ' + intHour + '시 '
                }
                else if (parseInt(timeValue.slice(0,2)) == 12){
                    time.innerHTML = '오후 ' + intHour + '시 '
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
                if (parseInt(day) < parseInt(todayDate) || (intHour <= intTodayHour && intMin <= intTodayMin)){
                    planName.className += ' past_plan'
                }

                for (var dateDiv of date){
                    if (dateDiv.innerText.split('\n')[0].slice(0, -1) == day){
                        dateDiv.appendChild(li)
                    }
                }
            }
            
            var location = document.getElementsByClassName('today')[0].offsetTop
            document.getElementsByClassName('plan')[0].scrollTop = location - 150
        }
    </script>
</body>
</html>