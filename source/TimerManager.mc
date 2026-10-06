import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Timer;

var departureMinutes as Number?;
var currentTime as Number?;
var timeLeft as Number?;

var minuteCountdown = 60;
var minuteTimer as Timer.Timer?;
var secondTicker as Timer.Timer?;

var updateTimer as Timer.Timer?;

class TimerManager{
    function initialize() {
    }

    function getTime() as Void{
        var timeNow = System.getClockTime();
        currentTime = timeNow.hour * 60 + timeNow.min;
    }

    public function setTimeLeft(currentMinutes as Number, currentSeconds as Number?) as Void{
        departureMinutes = currentMinutes;
        getTime();
        timeLeft = currentMinutes - currentTime;
        //change view to seconds when 1 min left
        var secondsLeft = timeLeft * 60;
        var secondsRemaining = secondsLeft - 60;
        if(secondsRemaining >= 0 && minuteTimer == null){
            minuteTimer = new Timer.Timer();
            minuteTimer.start(method(:oneMinuteCallback), secondsRemaining * 1000, false);
        }
    }

//merge timer logic
    function oneMinuteCallback() as Void{
        if(updateTimer != null){
            updateTimer.stop();
        }
        //possibly recreated each second
        secondTicker = new Timer.Timer();
        secondTicker.start(method(:secondsCallback), 1000, true);
        options.setTimeUnit("sec");
    }

    function secondsCallback() as Void{
        //update minuteCountdown after decrementing
        timeLeft = minuteCountdown - 1;
        minuteCountdown = timeLeft;
        System.println(timeLeft);
        WatchUi.requestUpdate();
        if(minuteCountdown == 0){
            journey.setCounter();
            minuteCountdown = 60;
            secondTicker.stop();
            updateTimer.start(timers.method(:timerCallback), 20000, true);
            minuteTimer = null;
            journey.departurePointer();
            options.setTimeUnit("min");
        }
    }

    public function timerCallback() as Void{
        setTimeLeft(departureMinutes, null);
        WatchUi.requestUpdate();
    }

    //naming to avoid confusion with formatData
    //styles date after user choice



}