import 'package:weather_app/core/weather/weather_enum.dart';
import 'package:weather_app/src/Home/domin/entity/weather_entity.dart';

class WeatherModel extends WeatherEntity {
  const WeatherModel({
    required super.location,
    required super.current,
    required super.hourly,
    required super.daily,
  });

  factory WeatherModel.fromJson(
    Map<String, dynamic> json,
    String locationName,
  ) {
    final currentJson = json['current'] as Map<String, dynamic>? ?? {};
    final hourlyJson = json['hourly'] as Map<String, dynamic>? ?? {};
    final dailyJson = json['daily'] as Map<String, dynamic>? ?? {};

    return WeatherModel(
      location: LocationModel.fromOpenMeteoJson(json, customName: locationName),
      current: CurrentWeatherModel.fromOpenMeteoJson(currentJson),
      hourly: HourlyWeatherModel.fromOpenMeteoJsonList(hourlyJson),
      daily: DailyWeatherModel.fromOpenMeteoJsonList(dailyJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': (location as LocationModel).toJson(),
      'current': (current as CurrentWeatherModel).toJson(),
      'hourly': hourly
          .map((item) => (item as HourlyWeatherModel).toJson())
          .toList(),
      'daily': daily
          .map((item) => (item as DailyWeatherModel).toJson())
          .toList(),
    };
  }
}

class LocationModel extends LocationEntity {
  const LocationModel({
    required super.name,
    required super.country,
    required super.region,
    required super.latitude,
    required super.longitude,
    required super.localTime,
  });

  factory LocationModel.fromOpenMeteoJson(
    Map<String, dynamic> json, {
    required String customName,
  }) {
    return LocationModel(
      name: customName,
      country: json['timezone'] as String? ?? '',
      region: json['timezone_abbreviation'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      localTime: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      'region': region,
      'latitude': latitude,
      'longitude': longitude,
      'localTime': localTime.toIso8601String(),
    };
  }
}

class CurrentWeatherModel extends CurrentWeatherEntity {
  const CurrentWeatherModel({
    required super.temperature,
    required super.feelsLike,
    required super.condition,
    required super.conditionText,
    required super.description,
    required super.windSpeed,
    required super.windDirection,
    required super.humidity,
    required super.pressure,
    required super.visibility,
    required super.uvIndex,
    required super.lastUpdated,
  });

  factory CurrentWeatherModel.fromOpenMeteoJson(Map<String, dynamic> json) {
    final int weatherCode = (json['weather_code'] as num?)?.toInt() ?? 0;
    final bool isDay = (json['is_day'] as num?)?.toInt() != 0;
    final WeatherCondition condition = _mapWmoCodeToCondition(
      weatherCode,
      isDay: isDay,
    );

    return CurrentWeatherModel(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      feelsLike: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      condition: condition,
      conditionText: _mapWmoCodeToText(weatherCode),
      description: _mapWmoCodeToText(weatherCode),
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      windDirection: '',
      humidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      pressure: (json['surface_pressure'] as num?)?.toDouble() ?? 0.0,
      // Open-Meteo returns visibility in meters; convert to km for display.
      visibility: ((json['visibility'] as num?)?.toDouble() ?? 0.0) / 1000,
      uvIndex: (json['uv_index'] as num?)?.toDouble() ?? 0.0,
      lastUpdated:
          DateTime.tryParse(json['time'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'feelsLike': feelsLike,
      'condition': condition.name,
      'conditionText': conditionText,
      'description': description,
      'windSpeed': windSpeed,
      'windDirection': windDirection,
      'humidity': humidity,
      'pressure': pressure,
      'visibility': visibility,
      'uvIndex': uvIndex,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

class HourlyWeatherModel extends HourlyWeatherEntity {
  const HourlyWeatherModel({
    required super.time,
    required super.label,
    required super.temperature,
    required super.condition,
    required super.conditionText,
    required super.precipitationChance,
  });

  static List<HourlyWeatherModel> fromOpenMeteoJsonList(
    Map<String, dynamic> json,
  ) {
    final times = List<String>.from(json['time'] ?? []);
    final temps = json['temperature_2m'] as List<dynamic>? ?? [];
    final codes = json['weather_code'] as List<dynamic>? ?? [];
    final precip = json['precipitation_probability'] as List<dynamic>? ?? [];
    final isDayList = json['is_day'] as List<dynamic>? ?? [];

    final List<HourlyWeatherModel> list = [];
    for (int i = 0; i < times.length; i++) {
      final dateTime = DateTime.tryParse(times[i]) ?? DateTime.now();
      final code = (codes.length > i) ? (codes[i] as num).toInt() : 0;
      final temp = (temps.length > i) ? (temps[i] as num).toDouble() : 0.0;
      final chance = (precip.length > i) ? (precip[i] as num).toDouble() : 0.0;
      // Default to day (true) if is_day wasn't requested/returned, rather
      // than silently guessing night and mislabeling every hour.
      final isDay = (isDayList.length > i)
          ? (isDayList[i] as num).toInt() != 0
          : true;

      list.add(
        HourlyWeatherModel(
          time: dateTime,
          label: '${dateTime.hour}:00',
          temperature: temp,
          condition: _mapWmoCodeToCondition(code, isDay: isDay),
          conditionText: _mapWmoCodeToText(code),
          precipitationChance: chance,
        ),
      );
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time.toIso8601String(),
      'label': label,
      'temperature': temperature,
      'condition': condition.name,
      'conditionText': conditionText,
      'precipitationChance': precipitationChance,
    };
  }
}

class DailyWeatherModel extends DailyWeatherEntity {
  const DailyWeatherModel({
    required super.date,
    required super.label,
    required super.minTemperature,
    required super.maxTemperature,
    required super.condition,
    required super.conditionText,
    required super.precipitationChance,
    required super.windSpeed,
    required super.humidity,
    required super.uvIndex,
    super.sunrise,
    super.sunset,
  });

  static List<DailyWeatherModel> fromOpenMeteoJsonList(
    Map<String, dynamic> json,
  ) {
    final times = List<String>.from(json['time'] ?? []);
    final maxTemps = json['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = json['temperature_2m_min'] as List<dynamic>? ?? [];
    final codes = json['weather_code'] as List<dynamic>? ?? [];
    final precipMax =
        json['precipitation_probability_max'] as List<dynamic>? ?? [];
    final windMax = json['wind_speed_10m_max'] as List<dynamic>? ?? [];
    final sunrises = List<String>.from(json['sunrise'] ?? []);
    final sunsets = List<String>.from(json['sunset'] ?? []);

    final List<DailyWeatherModel> list = [];
    for (int i = 0; i < times.length; i++) {
      final date = DateTime.tryParse(times[i]) ?? DateTime.now();
      final code = (codes.length > i) ? (codes[i] as num).toInt() : 0;

      list.add(
        DailyWeatherModel(
          date: date,
          label: _getWeekdayName(date.weekday),
          minTemperature: (minTemps.length > i)
              ? (minTemps[i] as num).toDouble()
              : 0.0,
          maxTemperature: (maxTemps.length > i)
              ? (maxTemps[i] as num).toDouble()
              : 0.0,
          // Daily icons intentionally ignore day/night — always the "day"
          // condition for a given code, since a whole day shouldn't show a
          // moon icon just because it's currently night when this parses.
          condition: _mapWmoCodeToCondition(code, isDay: true),
          conditionText: _mapWmoCodeToText(code),
          precipitationChance: (precipMax.length > i)
              ? (precipMax[i] as num).toDouble()
              : 0.0,
          windSpeed: (windMax.length > i)
              ? (windMax[i] as num).toDouble()
              : 0.0,
          // Open-Meteo's daily block has no relative-humidity aggregate field
          // (unlike current/hourly), so this stays 0 unless you switch to
          // computing it yourself from the hourly humidity values per day.
          humidity: 0,
          // Same gap for UV: add 'uv_index_max' to the daily query params to
          // populate this instead of leaving it at 0.
          uvIndex: 0.0,
          sunrise: (sunrises.length > i)
              ? DateTime.tryParse(sunrises[i])
              : null,
          sunset: (sunsets.length > i) ? DateTime.tryParse(sunsets[i]) : null,
        ),
      );
    }
    return list;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'label': label,
      'minTemperature': minTemperature,
      'maxTemperature': maxTemperature,
      'condition': condition.name,
      'conditionText': conditionText,
      'precipitationChance': precipitationChance,
      'windSpeed': windSpeed,
      'humidity': humidity,
      'uvIndex': uvIndex,
      'sunrise': sunrise?.toIso8601String(),
      'sunset': sunset?.toIso8601String(),
    };
  }
}

// Helper WMO Decoders
WeatherCondition _mapWmoCodeToCondition(int code, {bool isDay = true}) {
  switch (code) {
    case 0:
    case 1:
      return isDay ? WeatherCondition.sunny : WeatherCondition.clearNight;
    case 2:
      return isDay ? WeatherCondition.sunny : WeatherCondition.clearNight;
    case 3:
      return WeatherCondition.cloudy;
    case 45:
    case 48:
      return WeatherCondition.fog;
    case 51:
    case 61:
    case 80:
      return WeatherCondition.rain;
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return WeatherCondition.snow;
    case 95:
    case 96:
    case 99:
      return WeatherCondition.thunder;
    default:
      return isDay ? WeatherCondition.sunny : WeatherCondition.clearNight;
  }
}

String _mapWmoCodeToText(int code) {
  switch (code) {
    case 0:
      return 'Clear sky';
    case 1:
      return 'Mainly clear';
    case 2:
      return 'Partly cloudy';
    case 3:
      return 'Overcast';
    case 45:
    case 48:
      return 'Foggy';
    case 51:
    case 61:
      return 'Rain';
    case 80:
      return 'Rain showers';
    case 71:
    case 73:
    case 75:
    case 77:
    case 85:
    case 86:
      return 'Snow';
    case 95:
    case 96:
    case 99:
      return 'Thunderstorm';
    default:
      return 'Clear';
  }
}

String _getWeekdayName(int weekday) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[(weekday - 1) % 7];
}
