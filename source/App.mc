import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

var data as EnturClient?;
var journey as DepartureList?;
var timers as Countdown?;
var options as Options?;
//manage the life cycle of an app
class App extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        data = new EnturClient();
        journey = new DepartureList();
        timers = new Countdown();
        options = new Options();
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        
        
        return [ new View(), new Delegate() ];
    }
}

function getApp() as App {
    return Application.getApp() as App;
}