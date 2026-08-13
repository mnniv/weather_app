import 'package:dartz/dartz.dart';
import 'package:weather_app/core/params/location_params.dart';
import 'package:weather_app/src/Home/domin/entity/weather_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repostreis/home_repostreis.dart';

class GetWeather {
  final HomeRepostreis repostris;
  GetWeather({required this.repostris});
  Future<Either<Failure, WeatherEntity?>> call(LocationParams params) async {
    return repostris.getcurrentweather(params);
  }
}
