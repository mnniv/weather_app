import 'package:dartz/dartz.dart';
import 'package:weather_app/src/Home/domin/entity/city_search_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repostreis/home_repostreis.dart';

class SearchCityCase {
  final HomeRepostreis repostris;
  SearchCityCase({required this.repostris});
  Future<Either<Failure, List<CitySearchEntity>?>> call(String city) async {
    return repostris.searchCity(city);
  }
}
