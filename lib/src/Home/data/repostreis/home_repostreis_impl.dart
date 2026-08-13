import 'package:dartz/dartz.dart';
import 'package:weather_app/core/Netwirking/checkinternet.dart';

import 'package:weather_app/core/errors/failure.dart';

import 'package:weather_app/core/params/location_params.dart';

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

        // await homeLocalDataSource.cachedGlbalStatics(globalStatics);

        return Right(weather);
      } catch (e) {
        print("Error fetching Home from API: ${e.toString()}");
        if (e.toString() == "Exception: Refresh token failed") {
          return Left(Failure(errMessage: "refresh Token Expired"));
        }
        return Left(Failure(errMessage: e.toString()));
      }
    } else {
      return Left(Failure(errMessage: "No internet & no cached data"));
    }
  }
}
