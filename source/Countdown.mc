//TODO
/*
- handle cases where a bus is delayed so Journey is updated with new time, if possible
- refactor methods to be more modular and readable; currently overly reliant on calling eachother
*/
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Timer;
//module
using TimeUtils;

var departureSec as Number?;
var nowSec as Number?;
var displayCountdown as Number?;

var countdownSec;
var secondTicker as Timer.Timer?;
var lastMinuteTimer as Timer.Timer?;
var refreshTimer as Timer.Timer?;
var currentTime as String?;

class Countdown{
    function initialize() {
    }

    // store current clock time as sec. since midnight
    function getNowSec() as Void{
        var timeNow = System.getClockTime();
        nowSec = (timeNow.hour * 3600) + (timeNow.min * 60 ) + timeNow.sec;
    }

    //set current time in View
    function setCurrentTime() as Void{
        //temporary solution!
        var clockTime = System.getClockTime();
        currentTime = clockTime.hour + ":" + clockTime.min;
    }

    // work out secs left to a departure and prepare; next trip, sec countdown, or time unit displayed
    public function startCountdown(currentSeconds as Number?) as Void{
        departureSec = currentSeconds;
        getNowSec();
        setCurrentTime();
        //calculate seconds left - should be revised
        var secondsLeft = (currentSeconds - nowSec);
        System.println("current secondsLeft value (seconds): " + secondsLeft);
        countdownSec = secondsLeft;
        if(secondsLeft <= 0){
            resetTimers();
        }else if(secondsLeft >= 1 && secondsLeft <= 60){
            onLastMinute();
        }else{
            //integer division discards decimal; ensures correct minute counting
            displayCountdown = (secondsLeft + 59) / 60;
            options.setTimeUnit("min");
            System.println("currently displays Minutes");
            if(lastMinuteTimer != null){
                lastMinuteTimer.stop();
            }
            lastMinuteTimer = new Timer.Timer();
            lastMinuteTimer.start(method(:onRefresh), (secondsLeft - 60) * 1000, false);
        }
    }

// on last minute: stop countdown to display seconds till departure
    function onLastMinute() as Void{
        if(refreshTimer != null){
            refreshTimer.stop();
        }
        if(secondTicker != null){
            secondTicker.stop();
        }
        secondTicker = new Timer.Timer();
        secondTicker.start(method(:perSecond), 1000, true);
    }

// run last 60 seconds of a trip, then call resetTimers
    function perSecond() as Void{
        //update minuteCountdown after decrementing
        displayCountdown = countdownSec - 1;
        options.setTimeUnit("sec");
        System.println("currently displays Seconds");
        countdownSec = displayCountdown;
        System.println(displayCountdown);
        WatchUi.requestUpdate();
        if(countdownSec <= 0){
            resetTimers();
        }
    }

// reset timers, move to next departure and set displayed time unit to minutes
// logic needs improvements
    function resetTimers() as Void{
        journey.setCounter();
        if(secondTicker != null){
            secondTicker.stop();
        }
        if(refreshTimer != null){
            refreshTimer.stop();
        }
        if(lastMinuteTimer != null){
            lastMinuteTimer.stop();
        }
        refreshTimer.start(timers.method(:onRefresh), 20000, true);
        journey.departurePointer();
    }

// runs every 20s, recalc. countdown for current departure and update display
    public function onRefresh() as Void{
        startCountdown(departureSec);
        System.println("time left: " + displayCountdown);
        WatchUi.requestUpdate();
    }
}