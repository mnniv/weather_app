import 'package:equatable/equatable.dart';
import 'package:weather_app/src/Home/domin/entity/city_search_entity.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class GetWeatherEvent extends HomeEvent {
  const GetWeatherEvent();

  @override
  List<Object?> get props => [];
}

class SearchCityEvent extends HomeEvent {
  final String query;
  SearchCityEvent(this.query);
}

class SelectCityEvent extends HomeEvent {
  final CitySearchEntity city;
  SelectCityEvent(this.city);
}
