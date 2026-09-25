import Toybox.Graphics;
import Toybox.WatchUi;

//a View is an object that represents a page within an app
class View extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    // Load your resources here - Device context
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}

//view 1
//- name, aimedArrivalTime, aimedDepartureTime, expectedArrivalTime, expectedDepartureTime, date, destinationDisplay, 