import 'package:equatable/equatable.dart';
import 'package:weather_app/src/Home/domin/entity/weather_entity.dart';

enum HomeStatus { initial, loading, success, failure , noInternet }

class HomeState extends Equatable {
  final HomeStatus status;
  final WeatherEntity? weather;
  final String? errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.weather,
    this.errorMessage,
  });

  HomeState copyWith({
    HomeStatus? status,
    WeatherEntity? weather,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      weather: weather ?? this.weather,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, weather, errorMessage];
}
