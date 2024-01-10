import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time.Gregorian;
import Toybox.Weather;
using Toybox.Complications as Complications;

class CirclesView extends WatchUi.WatchFace {
  var screenWidth = 0;
  var screenHeight = 0;
  var heartIcon;
  var heartIconDisabled;
  var timeFont;
  var weatherIcons;
  var lowPowerFont;
  var isSleepMode = false;
  var timeXOffset = 0;
  var timeYOffset = 0;
  var ivoryColor;
  var orangeColor;

  function initialize() {
    WatchFace.initialize();

    heartIcon = Application.loadResource(Rez.Drawables.HeartIcon);
    heartIconDisabled = Application.loadResource(
      Rez.Drawables.HeartIcon_Disabled
    );
    timeFont = Application.loadResource(Rez.Fonts.TimeFont);
    weatherIcons = Application.loadResource(Rez.Fonts.WeatherFont);
    lowPowerFont = Application.loadResource(Rez.Fonts.LowPowerFont);
    ivoryColor = 0xd3d3cb;
    orangeColor = 0xb9cbcb;
  }

  // Load your resources here
  function onLayout(dc as Dc) as Void {
    setLayout(Rez.Layouts.WatchFace(dc));

    screenWidth = dc.getWidth();
    screenHeight = dc.getHeight();
  }

  // Called when this View is brought to the foreground. Restore
  // the state of this View and prepare it to be shown. This includes
  // loading resources into memory.
  function onShow() as Void {}

  // Update the view
  function onUpdate(dc as Dc) as Void {
    View.onUpdate(dc);
    if (isSleepMode) {
      var direction = Math.rand() % 360;
      var angle = Math.toRadians(direction);

      var deltaX = 5 * Math.cos(angle);
      var deltaY = 5 * Math.sin(angle);

      if (timeXOffset + deltaX < 85 && timeXOffset + deltaX > -85) {
        timeXOffset = timeXOffset + deltaX;
      } else if (timeXOffset - deltaX < 85 && timeXOffset - deltaX > -85) {
        timeXOffset = timeXOffset - deltaX;
      }

      if (timeYOffset + deltaY < 85 && timeYOffset + deltaY > -85) {
        timeYOffset = timeYOffset + deltaY;
      } else if (timeYOffset - deltaY < 85 && timeYOffset - deltaY > -85) {
        timeYOffset = timeYOffset - deltaY;
      }
    }

    setTime(dc);

    if (!isSleepMode) {
      // Set the date field
      setDate(dc);

      // Set HR
      setHR(dc);

      // Set Sunrise or Sunset time
      setSunRiseSunSet(dc);

      // Set weather
      setWeather(dc);

      setBattery(dc);
    }
  }

  // Called when this View is removed from the screen. Save the
  // state of this View here. This includes freeing resources from
  // memory.
  function onHide() as Void {}

  // The user has just looked at their watch. Timers and animations may be started here.
  function onExitSleep() as Void {
    isSleepMode = false;
    timeXOffset = 0;
    timeYOffset = 0;
  }

  // Terminate any active timers and prepare for slow updates.
  function onEnterSleep() as Void {
    isSleepMode = true;
    timeXOffset = 0;
    timeYOffset = 0;
  }

  private function setTime(dc as Dc) as Void {
    // Get the current time and format it correctly
    var timeFormat = "$1$:$2$";
    var clockTime = System.getClockTime();
    var hours = clockTime.hour;
    if (!System.getDeviceSettings().is24Hour) {
      if (hours == 0) {
        hours = 12;
      } else if (hours > 12) {
        hours = hours - 12;
      }
    } else {
      timeFormat = "$1$$2$";
      hours = hours.format("%02d");
    }
    var timeString = Lang.format(timeFormat, [
      hours,
      clockTime.min.format("%02d"),
    ]);
    //0xfa861e
    dc.setColor(0xa5a5a5, Graphics.COLOR_TRANSPARENT);

    var font = isSleepMode ? lowPowerFont : timeFont;
    // Draw the time text
    dc.drawText(
      screenWidth / 2 + timeXOffset,
      screenHeight / 2 - dc.getFontHeight(font) / 2 + timeYOffset,
      font,
      timeString,
      Graphics.TEXT_JUSTIFY_CENTER
    );
  }

  private function setDate(dc as Dc) as Void {
    var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
    var dateString = Lang.format("$1$ $2$ $3$", [
      today.day_of_week,
      today.day,
      today.month,
    ]);

    dc.setColor(0xada7a7, Graphics.COLOR_TRANSPARENT);

    var robotoItalic = Graphics.getVectorFont({
      :face => "RobotoItalic",
      :size => 56,
    });

    dc.drawText(
      screenWidth / 2,
      screenHeight / 2 + dc.getFontHeight(timeFont) / 2 - 6,
      robotoItalic, //Graphics.FONT_SYSTEM_SMALL,
      dateString,
      Graphics.TEXT_JUSTIFY_CENTER
    );
  }

  private function setHR(dc as Dc) as Void {
    var font = Graphics.FONT_SYSTEM_SMALL;

    try {
      var comp = Complications.getComplication(
        new Complications.Id(Complications.COMPLICATION_TYPE_HEART_RATE)
      );

      var hrText = comp.value != null ? comp.value.format("%d") : "--";

      dc.setColor(ivoryColor, Graphics.COLOR_TRANSPARENT);

      dc.drawText(
        screenWidth / 2,
        5,
        font,
        hrText,
        Graphics.TEXT_JUSTIFY_CENTER
      );

      var hrTextDims = dc.getTextDimensions(hrText, font);

      dc.drawBitmap(screenWidth / 2 + hrTextDims[0] / 2 + 4, 20, heartIcon);
    } catch (e) {
      dc.drawText(screenWidth / 2, 5, font, "--", Graphics.TEXT_JUSTIFY_CENTER);
      var textDims = dc.getTextDimensions("--", font);
      dc.drawBitmap(
        screenWidth / 2 + textDims[0] / 2 + 4,
        20,
        heartIconDisabled
      );
    }
  }

  private function setSunRiseSunSet(dc as Dc) as Void {
    var currentCond = Weather.getCurrentConditions();

    var sunriseMoment = Weather.getSunrise(
      currentCond.observationLocationPosition,
      Time.now()
    );
    var sunsetMoment = Weather.getSunset(
      currentCond.observationLocationPosition,
      Time.now()
    );
    var now = Time.now();

    var dateString = "--";
    var isSunRise = true;
    if (now.lessThan(sunriseMoment) || now.greaterThan(sunsetMoment)) {
      var moment = Gregorian.info(sunriseMoment, Time.FORMAT_MEDIUM);
      dateString = Lang.format("$1$:$2$", [
        moment.hour,
        moment.min.format("%02d"),
      ]);
    } else {
      var moment = Gregorian.info(sunsetMoment, Time.FORMAT_MEDIUM);
      dateString = Lang.format("$1$:$2$", [
        moment.hour - 12,
        moment.min.format("%02d"),
      ]);
      isSunRise = false;
    }

    dc.setColor(ivoryColor, Graphics.COLOR_TRANSPARENT);

    dc.drawText(
      60,
      85,
      Graphics.FONT_SYSTEM_SMALL,
      dateString,
      Graphics.TEXT_JUSTIFY_LEFT
    );

    var timeDims = dc.getTextDimensions(dateString, Graphics.FONT_SYSTEM_SMALL);
    dc.setColor(orangeColor, Graphics.COLOR_TRANSPARENT);
    var rise = WeatherIcons.getIcon(WeatherIcons.Sunrise);
    var set = WeatherIcons.getIcon(WeatherIcons.Sunset);

    var weatherIcon = isSunRise ? rise : set;
    dc.drawText(
      60 + timeDims[0] / 2 - 20,
      85 - timeDims[1] / 2 - 15,
      weatherIcons,
      weatherIcon.toString(),
      Graphics.TEXT_JUSTIFY_LEFT
    );
  }

  private function setWeather(dc as Dc) as Void {
    var currentConditions = Weather.getCurrentConditions();
    var currentTemp = "--";
    if (
      currentConditions != null &&
      currentConditions.temperature != null &&
      currentConditions.feelsLikeTemperature != null
    ) {
      var tempF = (currentConditions.temperature * 9) / 5 + 32;
      var feelsLike = (currentConditions.feelsLikeTemperature * 9) / 5 + 32;
      if ((feelsLike - tempF).abs() > 1) {
        currentTemp = tempF.format("%d") + "(" + feelsLike.format("%d") + ")F";
      } else {
        currentTemp = tempF.format("%d") + "F";
      }
    }

    dc.setColor(ivoryColor, Graphics.COLOR_TRANSPARENT);

    dc.drawText(
      screenWidth - 65,
      85,
      Graphics.FONT_SYSTEM_SMALL,
      currentTemp,
      Graphics.TEXT_JUSTIFY_RIGHT
    );

    var weatherIcon = isNight()
      ? WeatherIcons.getNightWeather(currentConditions.condition)
      : WeatherIcons.getDayWeather(currentConditions.condition);

    var tempDims = dc.getTextDimensions(
      currentTemp,
      Graphics.FONT_SYSTEM_SMALL
    );
    dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    dc.drawText(
      screenWidth - 65 - tempDims[0] / 2,
      85 - tempDims[1] / 2 - 15,
      weatherIcons,
      weatherIcon.toString(),
      Graphics.TEXT_JUSTIFY_CENTER
    );
  }

  private function setBattery(dc as Dc) as Void {
    var battery = System.getSystemStats().battery;
    var vCenterOffset = 35;
    var top = screenHeight - vCenterOffset - 2;
    var height = 8;

    var hCenter = screenWidth / 2;
    var totalWidth = 136;
    var halfWidth = totalWidth / 2;
    var quarterWidth = totalWidth / 4;

    var extraLowHeight = battery < 25 ? 4 : 0;
    var extraWarnHeight = battery >= 25 && battery < 50 ? 4 : 0;
    var extraGoodHeight = battery >= 50 ? 4 : 0;

    // Very low battery rect
    dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(
      hCenter - halfWidth,
      top - extraLowHeight / 2,
      quarterWidth - 1,
      height + extraLowHeight
    );

    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.drawRectangle(
      hCenter - halfWidth - 1,
      top - extraLowHeight / 2 - 1,
      quarterWidth + 1,
      height + extraLowHeight + 2
    );

    // Warning battery rect
    dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(
      hCenter - halfWidth / 2,
      top - extraWarnHeight / 2,
      quarterWidth - 1,
      height + extraWarnHeight
    );
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.drawRectangle(
      hCenter - halfWidth / 2 - 1,
      top - extraWarnHeight / 2 - 1,
      quarterWidth + 1,
      height + extraWarnHeight + 2
    );

    // Good Battery rect
    dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
    dc.fillRectangle(
      hCenter,
      top - extraGoodHeight / 2,
      halfWidth,
      height + extraGoodHeight
    );
    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.drawRectangle(
      hCenter - 1,
      top - extraGoodHeight / 2 - 1,
      halfWidth + 2,
      height + extraGoodHeight + 2
    );

    if (battery < 25) {
      dc.setColor(Graphics.COLOR_DK_RED, Graphics.COLOR_TRANSPARENT);
    } else if (battery < 50) {
      dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
    } else {
      dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_TRANSPARENT);
    }

    var indicatorCenter = (battery / 100) * totalWidth + hCenter - halfWidth;

    dc.fillPolygon([
      [indicatorCenter - 6, top - 14],
      [indicatorCenter + 6, top - 14],
      [indicatorCenter, top - 6],
      [indicatorCenter - 6, top - 14],
    ]);

    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    dc.drawLine(indicatorCenter - 7, top - 15, indicatorCenter + 7, top - 15);
    dc.drawLine(indicatorCenter + 7, top - 15, indicatorCenter, top - 5);
    dc.drawLine(indicatorCenter, top - 5, indicatorCenter - 7, top - 15);
  }

  private function isNight() as Boolean {
    var currentCond = Weather.getCurrentConditions();

    var sunriseMoment = Weather.getSunrise(
      currentCond.observationLocationPosition,
      Time.now()
    );
    var sunsetMoment = Weather.getSunset(
      currentCond.observationLocationPosition,
      Time.now()
    );
    var now = Time.now();
    return now.lessThan(sunriseMoment) || now.greaterThan(sunsetMoment);
  }
}
