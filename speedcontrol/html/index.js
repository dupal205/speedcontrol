let transitionDelay;
CallBack["show"] = () => {
    if (transitionDelay) {
        clearTimeout(transitionDelay)
        transitionDelay = undefined;
    }
    $(".main").show(0,function() {
        $(this).addClass("active");
    });
}

CallBack["hide"] = () => {
    $(".main").removeClass("active");
    if (transitionDelay) clearTimeout(transitionDelay);
    transitionDelay = setTimeout(() => {
        $(".main").hide();
        transitionDelay = undefined;
    }, 250);
}

CallBack["screenXY"] = data => {
    if (data.result)
        $(".main").show();    
    else {
        $(".main").hide();
        return;
    }

    $(".main").css({top:data.y+"%", left:data.x+"%"});
}

CallBack["frontVehicle"] = data => {
    $("#a_plate").text(data.plate);
    $("#a_speed").text(data.speed);
    if (data.speed > 150)
        $("#a_maxspd").show();
    else
        $("#a_maxspd").hide();
}

CallBack["behindVehicle"] = data => {
    $("#b_plate").text(data.plate);
    $("#b_speed").text(data.speed);
    if (data.speed > 150)
        $("#b_maxspd").show();
    else
        $("#b_maxspd").hide();
}