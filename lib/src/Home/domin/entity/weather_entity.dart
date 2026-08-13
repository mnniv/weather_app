import 'package:weather_app/core/weather/weather_enum.dart';

class WeatherEntity {
  final LocationEntity location;
  final CurrentWeatherEntity current;
  final List<HourlyWeatherEntity> hourly;
  final List<DailyWeatherEntity> daily;

  const WeatherEntity({
    required this.location,
    required this.current,
    required this.hourly,
    required this.daily,
  });
}

class LocationEntity {
  final String name;
  final String country;
  final String region;
  final double latitude;
  final double longitude;
  final DateTime localTime;

  const LocationEntity({
    required this.name,
    required this.country,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.localTime,
  });
}

class CurrentWeatherEntity {
  final double temperature;
  final double feelsLike;
  final WeatherCondition condition;
  final String conditionText;
  final String description;

  final double windSpeed;
  final String windDirection;

  final int humidity;
  final double pressure;
  final double visibility;
  final double uvIndex;

  final DateTime lastUpdated;

  const CurrentWeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.conditionText,
    required this.description,
    required this.windSpeed,
    required this.windDirection,
    required this.humidity,
    required this.pressure,
    required this.visibility,
    required this.uvIndex,
    required this.lastUpdated,
  });
}

class HourlyWeatherEntity {
  final DateTime time;
  final String label;
  final double temperature;
  final WeatherCondition condition;
  final String conditionText;
  final double precipitationChance;

  const HourlyWeatherEntity({
    required this.time,
    required this.label,
    required this.temperature,
    required this.condition,
    required this.conditionText,
    required this.precipitationChance,
  });
}

class DailyWeatherEntity {
  final DateTime date;
  final String label;

  final double minTemperature;
  final double maxTemperature;

  final WeatherCondition condition;
  final String conditionText;

  final double precipitationChance;

  final double windSpeed;
  final int humidity;
  final double uvIndex;

  final DateTime? sunrise;
  final DateTime? sunset;

  const DailyWeatherEntity({
    required this.date,
    required this.label,
    required this.minTemperature,
    required this.maxTemperature,
    required this.condition,
    required this.conditionText,
    required this.precipitationChance,
    required this.windSpeed,
    required this.humidity,
    required this.uvIndex,
    this.sunrise,
    this.sunset,
  });
}