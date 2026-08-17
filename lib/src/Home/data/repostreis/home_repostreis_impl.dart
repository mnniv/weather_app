import 'package:dartz/dartz.dart';
import 'package:weather_app/core/Netwirking/checkinternet.dart';

import 'package:weather_app/core/errors/failure.dart';

import 'package:weather_app/core/params/location_params.dart';
import 'package:weather_app/src/Home/domin/entity/city_search_entity.dart';

import 'package:weather_app/src/Home/domin/entity/weather_entity.dart';

import '../../domin/repostreis/home_repostreis.dart';
import '../datasource/home_local_data_source.dart';
import '../datasource/home_remote_data_source.dart';

class HomeRepostreisImpl extends HomeRepostreis {
  final HomeLocalDataSource homeLocalDataSource;
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepostreisImpl({
    required this.homeLocalDataSource,
    required this.homeRemoteDataSource,
  });

  @override
  Future<Either<Failure, WeatherEntity>> getcurrentweather(
    LocationParams params,
  ) async {
    if (await NetworkUtil.hasInternet()) {
      try {
        final weather = await homeRemoteDataSource.getWeather(params: params);
        return Right(weather);
      } catch (e) {
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: "No internet connection"));
    }
  }

  @override
  Future<Either<Failure, List<CitySearchEntity>?>> searchCity(
    String city,
  ) async {
    if (await NetworkUtil.hasInternet()) {
      try {
        final list = await homeRemoteDataSource.searchCity(city);

        return Right(list);
      } catch (e) {
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: "No internet connection"));
    }
  }
}
