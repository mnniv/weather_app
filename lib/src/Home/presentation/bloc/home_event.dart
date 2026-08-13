import 'package:equatable/equatable.dart';

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
