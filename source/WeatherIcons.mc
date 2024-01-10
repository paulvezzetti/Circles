import Toybox.Lang;
import Toybox.Weather;

class WeatherIcons {
  public enum KeyCodes {
    Sunrise = 61521,
    Sunset = 61522,
  }

  static function getIcon(keyCode as KeyCodes) as Char {
    return (keyCode as Number).toChar();
  }

  static function getDayWeather(condition as Lang.Number) as Char {
    var keyCode = 0;
    switch (condition) {
      case Weather.CONDITION_WINDY:
        keyCode = 61440;
        break;
      case Weather.CONDITION_MOSTLY_CLOUDY:
      case Weather.CONDITION_PARTLY_CLEAR:
        keyCode = 61442;
        break;
      case Weather.CONDITION_FOG:
      case Weather.CONDITION_MIST:
        keyCode = 61443;
        break;
      case Weather.CONDITION_HAIL:
        keyCode = 61444;
        break;
      case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
        keyCode = 61445;
        break;
      case Weather.CONDITION_WINTRY_MIX:
      case Weather.CONDITION_LIGHT_RAIN_SNOW:
      case Weather.CONDITION_RAIN_SNOW:
      case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
      case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN_SNOW:
        keyCode = 61446;
        break;
      case Weather.CONDITION_RAIN:
      case Weather.CONDITION_HEAVY_RAIN:
      case Weather.CONDITION_CHANCE_OF_SHOWERS:
        keyCode = 61448;
        break;
      case Weather.CONDITION_SCATTERED_SHOWERS:
      case Weather.CONDITION_UNKNOWN_PRECIPITATION:
      case Weather.CONDITION_SHOWERS:
        keyCode = 61449;
        break;
      case Weather.CONDITION_SNOW:
      case Weather.CONDITION_LIGHT_SNOW:
      case Weather.CONDITION_CHANCE_OF_SNOW:
      case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
        keyCode = 61450;
        break;
      case Weather.CONDITION_LIGHT_RAIN:
      case Weather.CONDITION_LIGHT_SHOWERS:
      case Weather.CONDITION_DRIZZLE:
      case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
        keyCode = 61451;
        break;
      case Weather.CONDITION_PARTLY_CLOUDY:
      case Weather.CONDITION_MOSTLY_CLEAR:
        keyCode = 61452;
        break;
      case Weather.CONDITION_CLEAR:
      case Weather.CONDITION_FAIR:
      case Weather.CONDITION_THIN_CLOUDS:
        keyCode = 61453;
        break;
      case Weather.CONDITION_THUNDERSTORMS:
      case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
        keyCode = 61456;
        break;
      case Weather.CONDITION_SQUALL:
        keyCode = 61457;
        break;
      case Weather.CONDITION_HEAVY_RAIN_SNOW:
        keyCode = 61463;
        break;
      case Weather.CONDITION_HEAVY_SHOWERS:
        keyCode = 61465;
        break;
      case Weather.CONDITION_FLURRIES:
      case Weather.CONDITION_ICE_SNOW:
        keyCode = 61467;
        break;
      case Weather.CONDITION_CLOUDY:
        keyCode = 61505;
        break;
      case Weather.CONDITION_TORNADO:
        keyCode = 61526;
        break;
      case Weather.CONDITION_DUST:
        keyCode = 61539;
        break;
      case Weather.CONDITION_HEAVY_SNOW:
        keyCode = 61540;
        break;
      case Weather.CONDITION_HURRICANE:
      case Weather.CONDITION_TROPICAL_STORM:
        keyCode = 61555;
        break;
      case Weather.CONDITION_ICE:
        keyCode = 61558;
        break;
      case Weather.CONDITION_UNKNOWN:
        keyCode = 61563;
        break;
      case Weather.CONDITION_SAND:
      case Weather.CONDITION_SANDSTORM:
        keyCode = 61570;
        break;
      case Weather.CONDITION_FREEZING_RAIN:
      case Weather.CONDITION_SLEET:
        keyCode = 61621;
        break;
      case Weather.CONDITION_HAZY:
      case Weather.CONDITION_HAZE:
        keyCode = 61622;
        break;
      case Weather.CONDITION_SMOKE:
        keyCode = 61639;
        break;
      case Weather.CONDITION_VOLCANIC_ASH:
        keyCode = 61640;
        break;
    }
    return keyCode.toChar();
  }

    static function getNightWeather(condition as Lang.Number) as Char {
    var keyCode = 0;
    switch (condition) {
      case Weather.CONDITION_SQUALL:
        keyCode = 61457;
        break;
      case Weather.CONDITION_HEAVY_RAIN_SNOW:
        keyCode = 61463;
        break;
      case Weather.CONDITION_HEAVY_SHOWERS:
        keyCode = 61465;
        break;
      case Weather.CONDITION_FLURRIES:
      case Weather.CONDITION_ICE_SNOW:
        keyCode = 61467;
        break;
      case Weather.CONDITION_WINDY:
        keyCode = 61474;
        break;
      case Weather.CONDITION_HAIL:
        keyCode = 61476;
        break;
      case Weather.CONDITION_WINTRY_MIX:
      case Weather.CONDITION_LIGHT_RAIN_SNOW:
      case Weather.CONDITION_RAIN_SNOW:
      case Weather.CONDITION_CHANCE_OF_RAIN_SNOW:
        keyCode = 61478;
        break;
      case Weather.CONDITION_FREEZING_RAIN:
        keyCode = 61479;
        break;
      case Weather.CONDITION_RAIN:
      case Weather.CONDITION_HEAVY_RAIN:
      case Weather.CONDITION_CHANCE_OF_SHOWERS:
      case Weather.CONDITION_SCATTERED_SHOWERS:
      case Weather.CONDITION_UNKNOWN_PRECIPITATION:
      case Weather.CONDITION_SHOWERS:
        keyCode = 61480;
        break;
      case Weather.CONDITION_SNOW:
      case Weather.CONDITION_LIGHT_SNOW:
      case Weather.CONDITION_CHANCE_OF_SNOW:
      case Weather.CONDITION_CLOUDY_CHANCE_OF_SNOW:
        keyCode = 61482;
        break;
      case Weather.CONDITION_LIGHT_RAIN:
      case Weather.CONDITION_LIGHT_SHOWERS:
      case Weather.CONDITION_DRIZZLE:
      case Weather.CONDITION_CLOUDY_CHANCE_OF_RAIN:
        keyCode = 61483;
        break;
      case Weather.CONDITION_THUNDERSTORMS:
        keyCode = 61484;
        break;
      case Weather.CONDITION_CLEAR:
      case Weather.CONDITION_FAIR:
      case Weather.CONDITION_THIN_CLOUDS:
        keyCode = 61486;
        break;
      case Weather.CONDITION_CHANCE_OF_THUNDERSTORMS:
        keyCode = 61491;
        break;
      case Weather.CONDITION_SCATTERED_THUNDERSTORMS:
        keyCode = 61499;
        break;
      case Weather.CONDITION_FOG:
      case Weather.CONDITION_MIST:
      case Weather.CONDITION_HAZY:
      case Weather.CONDITION_HAZE:
        keyCode = 61514;
        break;
      case Weather.CONDITION_TORNADO:
        keyCode = 61526;
        break;
      case Weather.CONDITION_DUST:
        keyCode = 61539;
        break;
      case Weather.CONDITION_HEAVY_SNOW:
        keyCode = 61540;
        break;
      case Weather.CONDITION_HURRICANE:
      case Weather.CONDITION_TROPICAL_STORM:
        keyCode = 61555;
        break;
      case Weather.CONDITION_ICE:
        keyCode = 61558;
        break;
      case Weather.CONDITION_UNKNOWN:
        keyCode = 61563;
        break;
      case Weather.CONDITION_PARTLY_CLOUDY:
      case Weather.CONDITION_MOSTLY_CLEAR:
        keyCode = 61569;
        break;
      case Weather.CONDITION_SAND:
      case Weather.CONDITION_SANDSTORM:
        keyCode = 61570;
        break;
      case Weather.CONDITION_MOSTLY_CLOUDY:
      case Weather.CONDITION_PARTLY_CLEAR:
      case Weather.CONDITION_CLOUDY:
        keyCode = 61574;
        break;
      case Weather.CONDITION_FREEZING_RAIN:
      case Weather.CONDITION_SLEET:
        keyCode = 61621;
        break;
      case Weather.CONDITION_HAZY:
      case Weather.CONDITION_HAZE:
        keyCode = 61622;
        break;
      case Weather.CONDITION_SMOKE:
        keyCode = 61639;
        break;
      case Weather.CONDITION_VOLCANIC_ASH:
        keyCode = 61640;
        break;
    }
    return keyCode.toChar();
  }
}
