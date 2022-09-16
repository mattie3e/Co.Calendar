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

function changeMonthEvent(updown){
    var month = document.getElementsByClassName('month')[0]

    if (updown == 'up'){
        month.innerHTML = parseInt(month.innerHTML) + 1 + '월'

        if (month.innerHTML == '13월'){ month.innerHTML = '1월'}
    }
    else if (updown == 'down'){
        month.innerHTML = parseInt(month.innerHTML) - 1 + '월'

        if (month.innerHTML == '0월'){ month.innerHTML = '1월'}
    }
}

function modifyEvent(){
    console.log(event.target)

    console.log(event.target.innerHTML)

    var value = event.target.innerHTML
    var modify = document.createElement('input')
    modify.type = 'text'
    modify.value = value

    event.target.appendChild(modify)
}