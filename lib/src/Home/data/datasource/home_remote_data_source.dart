import 'package:weather_app/core/params/location_params.dart';
import 'package:weather_app/src/Home/data/model/city_search_model.dart';
import 'package:weather_app/src/Home/data/model/weather_model.dart';
import '../../../../core/Netwirking/api_consumer.dart';
import '../../../../core/Netwirking/dio_consumer.dart';
import '../../../../core/errors/error_model.dart';
import '../../../../core/errors/expentions.dart';

class HomeRemoteDataSource {
  static final HomeRemoteDataSource _instance = HomeRemoteDataSource._internal(
    DioConsumer(),
  );

  final ApiConsumer api;

  HomeRemoteDataSource._internal(this.api);

  factory HomeRemoteDataSource() {
    return _instance;
  }

  Future<WeatherModel> getWeather({required LocationParams params}) async {
    final response = await api.get(
      'https://api.open-meteo.com/v1/forecast',
      queryParameters: {
        'latitude': params.latitude,
        'longitude': params.longitude,

        'current':
            'temperature_2m,apparent_temperature,weather_code,wind_speed_10m,relative_humidity_2m,surface_pressure,visibility,uv_index,is_day',

        'hourly':
            'temperature_2m,apparent_temperature,weather_code,precipitation_probability,wind_speed_10m,relative_humidity_2m,uv_index,is_day',
        // Daily weather
        'daily':
            'weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_probability_max,wind_speed_10m_max',

        'timezone': 'auto',
        'forecast_days': '7',
      },
    );

    if (response is Map<String, dynamic>) {
      return WeatherModel.fromJson(response, params.locationName);
    }

    throw ServerException(
      ErrorModel(errorMessage: 'Failed to load weather', status: 500),
    );
  }

  Future<List<CitySearchModel>> searchCity(String query) async {
    final uri =
        'https://nominatim.openstreetmap.org/search'
        '?format=json&q=$query&addressdetails=1&limit=8';

    final response = await api.get(uri, headers: {'User-Agent': 'weather_app'});

    if (response is List) {
      final list = response
          .map((e) => CitySearchModel.fromJson(e as Map<String, dynamic>))
          .where((c) => c.name.isNotEmpty)
          .toList();
      return list;
    }

    throw ServerException(
      ErrorModel(errorMessage: 'Failed to load weather', status: 500),
    );
  }
}
