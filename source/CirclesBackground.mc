import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class Background extends WatchUi.Drawable {

    function initialize() {
        var dictionary = {
            :identifier => "Background"
        };

        Drawable.initialize(dictionary);
    }

    function draw(dc as Dc) as Void {
        // Set the background color then call to clear the screen
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();

        var screenWidth = dc.getWidth();
        var screenHeight = dc.getHeight();

        var floorsClimbedComp = Complications.getComplication(
            new Complications.Id(Complications.COMPLICATION_TYPE_FLOORS_CLIMBED)
        );
        var floorsClimbed = floorsClimbedComp.value != null ? floorsClimbedComp.value : 0; 

        var stressComp = Complications.getComplication(
            new Complications.Id(Complications.COMPLICATION_TYPE_STRESS)
        );
        var stress = stressComp.value != null ? stressComp.value : 0;

        // Body Battery out of 100
        var bodyBatteryComp = Complications.getComplication(
            new Complications.Id(Complications.COMPLICATION_TYPE_BODY_BATTERY)
        );
        var bodyBattery = bodyBatteryComp.value != null ? bodyBatteryComp.value : 0;

        dc.setColor(0x333333, 0x000000);

        var bodyBatteryRadius = screenWidth * 0.3 * (bodyBattery / 100.0);

        var bodyBatteryColor = 0x80005791;
        if (bodyBattery > 70) {
            bodyBatteryColor = 0xF0005791;
        } else if (bodyBattery < 30) {
            bodyBatteryColor = 0x30005791;
        }

        dc.setFill(bodyBatteryColor);
        dc.fillCircle(screenWidth * 0.65, screenHeight * 0.35, bodyBatteryRadius);

        var stressRadius = bodyBatteryRadius * (stress / 100.0);
        dc.setFill(0x80B9A44C);
        dc.fillCircle(screenWidth * 0.65, screenHeight * 0.35, stressRadius);

        var activityInfo = ActivityMonitor.getInfo();

        var stepPerc  = activityInfo.steps.toFloat() / activityInfo.stepGoal.toFloat();
        var stepRadius = screenWidth  / 4.0 * stepPerc;
        var stepCenter = stepPerc <= 1.2 ? stepRadius : screenWidth / 2 * 1.2 - stepRadius;

        dc.setFill(0x8000916E);
        dc.fillCircle(stepCenter, screenHeight / 2, stepRadius);

        var floorsPerc  = floorsClimbed.toFloat() / activityInfo.floorsClimbedGoal.toFloat();
        var floorRadius = screenHeight / 4.0 * floorsPerc;
        var floorsCenter = max(screenHeight * 0.80, screenHeight / 2.0 + floorRadius);

        dc.setFill(0x80EE6123);
        dc.fillCircle(screenWidth / 2.0, floorsCenter, floorRadius);
    }


    function min(x as Float, y as Float) {
        if (x < y) {
            return x;
        }
        return y;
    }

    function max(x as Float, y as Float) {
        if (x > y) {
            return x;
        }
        return y;
    }
}
