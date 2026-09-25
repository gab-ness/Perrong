import Toybox.Lang;
import Toybox.WatchUi;

//BehaviorDelegate handles behavior input events; such as physical buttons and touch
class Delegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new MenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}