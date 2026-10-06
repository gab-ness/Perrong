import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

var data as API_Data?;
var journey as JourneyManager?;
var timers as TimerManager?;
var options as Options?;
//manage the life cycle of an app
class App extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        data = new API_Data();
        journey = new JourneyManager();
        timers = new TimerManager();
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
//TODO:
//create API_Data object, implement onUpdate