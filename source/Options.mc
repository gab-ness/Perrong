import Toybox.Application;
import Toybox.Lang;
import Toybox.System;

var timeUnit = " minutt";
class Options{
    function initialize() {
    }
    // styling the visual date format
    function styleDate(storedDate as String?) as String{
        //more choices eventually
        var day = storedDate.substring(5, 7);
        var month = storedDate.substring(8, 10);
        var year = storedDate.substring(0, 4);
        var lookDate = day + "/" + month + "/" + year;
        return lookDate;
    }

    //(relocate out of Options) handle Hours
    function setTimeUnit(unit as String?) as Void{
        if(unit == "min"){
            timeUnit = " minutter";
        }
        if(unit == "sec"){
            timeUnit = " sekunder";
        }
    }
}