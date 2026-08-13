import 'package:weather_app/core/weather/weather_enum.dart';

WeatherCondition weatherConditionFromCode(int code) {
  switch (code) {
    // Clear
    case 0:
      return WeatherCondition.sunny;

    // Mainly clear / partly cloudy
    case 1:
    case 2:
      return WeatherCondition.cloudy;

    // Overcast
    case 3:
      return WeatherCondition.cloudy;

    // Fog
    case 45:
    case 48:
      return WeatherCondition.fog;

    // Drizzle
    case 51:
    case 53:
    case 55:
    case 56:
    case 57:
      return WeatherCondition.rain;

    // Rain
    case 61:
    case 63:
    case 65:
    case 66:
    case 67:
    case 80:
    case 81:
    case 82:
      return WeatherCondition.rain;

    // Snow
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return WeatherCondition.snow;

    // Thunderstorm
    case 95:
    case 96:
    case 99:
      return WeatherCondition.thunder;

    default:
      return WeatherCondition.sunny;
  }
}

