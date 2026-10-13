import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;
import Toybox.Communications;

var currentDeparture as Dictionary?;
var displayDate as String?;
var displayTime as String?;
var displayEndStop as String?;

class DepartureList{
    
    var infoTable as Array = [];
    var counter = 0;

    function initialize() {
    }
    //handle no trips received
    function departurePointer() as Void{
        if(infoTable.size() != 0){
            currentDeparture = infoTable[counter] as Dictionary;
            var departureHours = (currentDeparture["hours"] as String).toNumber();
            var departureMinutes = (currentDeparture["minutes"] as String).toNumber();
            var departureSeconds = (currentDeparture["seconds"] as String).toNumber();
            var totalSec = (departureHours * 3600) + (departureMinutes * 60) + departureSeconds;
            //time till departure
            //change var into 1 combined (?)
            timers.startCountdown(totalSec);
            displayDate = currentDeparture["date"] as String;
            displayTime = currentDeparture["time"] as String;
            displayEndStop = currentDeparture["destination"] as String;
        }
    }

    //set infoTable
    function setInfoTable(sortedStops as Dictionary) as Void{
        infoTable.add(sortedStops);
    }
    //handle counter
    function setCounter() as Void{
        if(counter < infoTable.size() - 1){
            counter++;
        }else{
            //wraparound logic
            counter = 0;
        }
        System.println("counter: " + counter);
    }
}