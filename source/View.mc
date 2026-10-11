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
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        if(currentDeparture == null){
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_MEDIUM, "Laster...", Graphics.TEXT_JUSTIFY_CENTER);
        }else{
            //current time
            dc.drawText(dc.getWidth()/2, 10, Graphics.FONT_SMALL, currentTime, Graphics.TEXT_JUSTIFY_CENTER);
            //transport direction
            dc.drawText(dc.getWidth()/2, 80, Graphics.FONT_SMALL, "Retning: " + displayEndStop, Graphics.TEXT_JUSTIFY_CENTER);
            //departure
            dc.drawText(dc.getWidth()/2, 125, Graphics.FONT_SMALL, "Avgang om " + displayCountdown + timeUnit, Graphics.TEXT_JUSTIFY_CENTER);
            //date
            dc.drawText(dc.getWidth()/2, 155, Graphics.FONT_SMALL, displayDate, Graphics.TEXT_JUSTIFY_CENTER);
            //time
            dc.drawText(dc.getWidth()/2, 190, Graphics.FONT_SMALL, "avgang kl: " + displayTime, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
