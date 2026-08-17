import 'package:weather_app/src/Home/domin/entity/city_search_entity.dart';
import 'package:weather_app/src/Home/domin/entity/weather_entity.dart';

enum HomeStatus { initial, loading, success, failure, noInternet }

class HomeState {
  final HomeStatus status;
  final WeatherEntity? weather;
  final String? errorMessage;
  final bool isRefreshing;

  final List<CitySearchEntity> searchResults;
  final bool isSearching;

  const HomeState({
    this.status = HomeStatus.initial,
    this.weather,
    this.errorMessage,
    this.isRefreshing = false,
    this.searchResults = const [],
    this.isSearching = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    WeatherEntity? weather,
    String? errorMessage,
    bool? isRefreshing,
    List<CitySearchEntity>? searchResults,
    bool? isSearching,
  }) {
    return HomeState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      errorMessage: errorMessage,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
