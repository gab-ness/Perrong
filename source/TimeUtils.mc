import Toybox.System;
import Toybox.Lang;
import Toybox.Timer;
module TimeUtils{

    function getTime() as String{
        var systemClock = System.getClockTime();
        var currentTime = systemClock.hour + ":" + systemClock.min;
        return currentTime;
    }
}