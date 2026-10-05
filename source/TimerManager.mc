import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Timer;

var departureMinutes as Number?;
public var currentTime as Number?;
public var timeLeft as Number?;
var counter = 0;
var minuteCountdown = 60;
var minuteTimer as Timer.Timer?;
var secondTicker as Timer.Timer?;
//view time
var timeUnit = " minutt";

public class TimeHandler{
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
        timeUnit = " sekund";
    }

    function secondsCallback() as Void{
        //update minuteCountdown after decrementing
        timeLeft = minuteCountdown - 1;
        minuteCountdown = timeLeft;
        System.println(timeLeft);
        WatchUi.requestUpdate();
        if(minuteCountdown == 0){
            counter++;
            System.println("counter: " + counter);
            minuteCountdown = 60;
            secondTicker.stop();
            updateTimer.start(handler.method(:timerCallback), 20000, true);
            minuteTimer = null;
            departurePointer();
            timeUnit = " minutt";
        }
    }

    public function timerCallback() as Void{
        setTimeLeft(departureMinutes, null);
        WatchUi.requestUpdate();
    }

    //naming to avoid confusion with formatData
    //styles date after user choice
    function styleDate(storedDate as String) as String{
        //more options eventually
        var day = storedDate.substring(5, 7);
        var month = storedDate.substring(8, 10);
        var year = storedDate.substring(0, 4);
        var lookDate = day + "/" + month + "/" + year;
        return lookDate;
    }

    //handles displayed time info for next trip
    function departurePointer() as Void{
        currentDeparture = infoTable[counter] as Dictionary;
        var departureHours = (currentDeparture["hours"] as String).toNumber();
        var departureMinutes = (currentDeparture["minutes"] as String).toNumber();
        var departureSeconds = (currentDeparture["seconds"] as String).toNumber();
        var departureTime = departureHours * 60 + departureMinutes;
        handler.setTimeLeft(departureTime, departureSeconds);
        displayDate = currentDeparture["date"] as String;
        displayTime = currentDeparture["time"] as String;
    }
}