import 'package:dartz/dartz.dart';
import 'package:weather_app/core/params/location_params.dart';
import 'package:weather_app/src/Home/domin/entity/weather_entity.dart';
import '../../../../core/errors/failure.dart';

abstract class HomeRepostreis {
  Future<Either<Failure, WeatherEntity>> getcurrentweather(
    LocationParams params,
  );
}
