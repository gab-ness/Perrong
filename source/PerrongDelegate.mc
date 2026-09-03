import Toybox.Lang;
import Toybox.WatchUi;

class PerrongDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new PerrongMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}