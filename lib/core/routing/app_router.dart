import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/routing/Routes.dart';
import 'package:weather_app/src/Home/data/datasource/home_local_data_source.dart';
import 'package:weather_app/src/Home/data/datasource/home_remote_data_source.dart';
import 'package:weather_app/src/Home/data/repostreis/home_repostreis_impl.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_bloc.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_event.dart';
import 'package:weather_app/src/Home/presentation/screen/home_page.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> navigatorkey =
      GlobalKey<NavigatorState>();

  static GoRouter buildRouter(String startRoute) {
    return GoRouter(
      navigatorKey: navigatorkey,
      initialLocation: startRoute,
      routes: [
        GoRoute(
          path: Routes.home,
          name: 'home',
          builder: (context, state) => BlocProvider(
            create: (context) => HomePageBloc(
              repostris: HomeRepostreisImpl(
                homeLocalDataSource: HomeLocalDataSource(),
                homeRemoteDataSource: HomeRemoteDataSource(),
              ),
            )..add(GetWeatherEvent( )),
            child: HomePage(),
          ),
        ),
      ],
    );
  }
}
