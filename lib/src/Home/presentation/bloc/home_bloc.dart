import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weather_app/core/params/location_params.dart';
import 'package:weather_app/src/Home/data/repostreis/home_repostreis_impl.dart';
import 'package:weather_app/src/Home/domin/usecase/get_weather.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_event.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_state.dart';

class HomePageBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepostreisImpl repostris;

  HomePageBloc({required this.repostris}) : super(HomeState()) {
    on<GetWeatherEvent>(_getWeather);
    on<SearchCityEvent>(_searchCity, transformer: restartable());
    on<SelectCityEvent>(_selectCity);
  }

  Future<void> _getWeather(
    GetWeatherEvent event,
    Emitter<HomeState> emit,
  ) async {
    final isRefresh = state.weather != null;

    emit(
      state.copyWith(
        status: isRefresh ? state.status : HomeStatus.loading,
        isRefreshing: isRefresh,
      ),
    );

    try {
      // ----------------------------------------
      // 1. Check location permission
      // ----------------------------------------
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          emit(
            state.copyWith(
              status: HomeStatus.failure,
              errorMessage: 'Location permission denied',
            ),
          );
          return;
        }
      }

      // ----------------------------------------
      // 2. Get current device location
      // ----------------------------------------
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

      // ----------------------------------------
      // 3. Reverse-geocode to a location name
      // ----------------------------------------
      String locationName = 'Unknown location';
      try {
        final placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          final city = place.locality?.isNotEmpty == true
              ? place.locality!
              : (place.subAdministrativeArea ?? place.administrativeArea ?? '');
          final country = place.country ?? '';
          locationName = city.isEmpty
              ? country
              : (country.isEmpty ? city : '$city, $country');
        }
      } catch (_) {
        locationName =
            '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
      }

      // ----------------------------------------
      // 4. Request weather
      // ----------------------------------------
      final result = await GetWeather(repostris: repostris).call(
        LocationParams(
          latitude: position.latitude,
          longitude: position.longitude,
          locationName: locationName,
        ),
      );

      // ----------------------------------------
      // 5. Handle result
      // ----------------------------------------
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: failure.errMessage == 'No internet connection'
                  ? HomeStatus.noInternet
                  : HomeStatus.failure,
              errorMessage: failure.errMessage,
              isRefreshing: false,
            ),
          );
        },
        (data) {
          emit(
            state.copyWith(
              status: HomeStatus.success,
              weather: data,
              isRefreshing: false,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: e.toString(),
          isRefreshing: false,
        ),
      );
    }
  }

  Future<void> _searchCity(
    SearchCityEvent event,
    Emitter<HomeState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(state.copyWith(searchResults: [], isSearching: false));
      return;
    }

    emit(state.copyWith(isSearching: true));

    await Future.delayed(const Duration(milliseconds: 450));

    try {
      final result = await repostris.searchCity(query);
      result.fold(
        (failure) =>
            emit(state.copyWith(searchResults: [], isSearching: false)),
        (results) => emit(
          state.copyWith(searchResults: results ?? [], isSearching: false),
        ),
      );
    } catch (e) {
      emit(state.copyWith(searchResults: [], isSearching: false));
    }
  }

  Future<void> _selectCity(
    SelectCityEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(status: HomeStatus.loading, searchResults: []));

    final result = await GetWeather(repostris: repostris).call(
      LocationParams(
        latitude: event.city.latitude,
        longitude: event.city.longitude,
        locationName: '${event.city.name}, ${event.city.country}',
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage: failure.errMessage,
        ),
      ),
      (data) => emit(state.copyWith(status: HomeStatus.success, weather: data)),
    );
  }
}
