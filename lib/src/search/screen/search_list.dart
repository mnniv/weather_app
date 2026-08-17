import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import 'package:weather_app/src/Home/domin/entity/city_search_entity.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_bloc.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_event.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_state.dart';
import 'package:weather_app/src/Home/presentation/widgets/weather_glass.dart';

class SearchQueryCubit extends Cubit<String> {
  SearchQueryCubit() : super('');

  void update(String value) => emit(value);
}

void showSearchList(BuildContext context, WeatherPalette pallette) {
  final homeBloc = BlocProvider.of<HomePageBloc>(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.12),
    builder: (sheetContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: homeBloc),
          BlocProvider(create: (_) => SearchQueryCubit()),
        ],
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(color: Colors.transparent),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,

              child: SearchList(pallette: pallette),
            ),
          ],
        ),
      );
    },
  );
}

class SearchList extends StatelessWidget {
  final WeatherPalette pallette;

  const SearchList({super.key, required this.pallette});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    final controller = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: SingleChildScrollView(
            child: WeatherGlass(
              palette: pallette,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: 4.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11.r),
                          color: pallette.glassBorder,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),

                    WeatherGlass(
                      palette: pallette,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.search,
                              color: pallette.foreground,
                              size: 20.sp,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: TextField(
                                controller: controller,
                                onChanged: (value) {
                                  context.read<SearchQueryCubit>().update(
                                    value,
                                  );
                                  context.read<HomePageBloc>().add(
                                    SearchCityEvent(value),
                                  );
                                },
                                style: TextStyleManger.BlackTitle.copyWith(
                                  color: pallette.foreground,
                                  fontSize: 14.sp,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search a city or country',
                                  hintStyle:
                                      TextStyleManger.BlackTitle.copyWith(
                                        color: pallette.foreground,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ),

                            BlocBuilder<SearchQueryCubit, String>(
                              builder: (context, query) {
                                if (query.isEmpty)
                                  return const SizedBox.shrink();
                                return InkWell(
                                  onTap: () {
                                    controller.clear();
                                    context.read<SearchQueryCubit>().update('');
                                    context.read<HomePageBloc>().add(
                                      SearchCityEvent(''),
                                    );
                                  },
                                  child: Icon(
                                    CupertinoIcons.clear,
                                    size: 20.sp,
                                    color: pallette.foreground,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    InkWell(
                      onTap: () {
                        context.read<HomePageBloc>().add(GetWeatherEvent());
                        context.pop();
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.location_solid,
                            color: pallette.foreground,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            'Use my current location',
                            style: TextStyleManger.BlackTitle.copyWith(
                              color: pallette.foreground,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 40.h),

                    BlocBuilder<SearchQueryCubit, String>(
                      builder: (context, query) {
                        return _buildSectionText(
                          query.trim().isEmpty ? 'POPULAR' : 'RESULTS',
                          pallette,
                        );
                      },
                    ),
                    SizedBox(height: 20.h),

                    BlocBuilder<SearchQueryCubit, String>(
                      builder: (context, query) {
                        if (query.trim().isEmpty) {
                          const curated = [
                            CitySearchEntity(
                              name: 'El Oued',
                              country: 'Algeria',
                              latitude: 33.368,
                              longitude: 6.867,
                            ),
                            CitySearchEntity(
                              name: 'Algiers',
                              country: 'Algeria',
                              latitude: 36.752,
                              longitude: 3.042,
                            ),
                            CitySearchEntity(
                              name: 'Paris',
                              country: 'France',
                              latitude: 48.857,
                              longitude: 2.352,
                            ),
                            CitySearchEntity(
                              name: 'Dubai',
                              country: 'UAE',
                              latitude: 25.204,
                              longitude: 55.271,
                            ),
                          ];
                          return Column(
                            children: curated
                                .map(
                                  (city) => PopularSearch(
                                    city: city,
                                    pallette: pallette,
                                    onTap: () {
                                      context.read<HomePageBloc>().add(
                                        SelectCityEvent(city),
                                      );
                                      context.pop();
                                    },
                                  ),
                                )
                                .toList(),
                          );
                        }

                        return BlocBuilder<HomePageBloc, HomeState>(
                          buildWhen: (previous, current) =>
                              previous.searchResults != current.searchResults ||
                              previous.isSearching != current.isSearching,
                          builder: (context, state) {
                            if (state.isSearching) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: pallette.foreground,
                                  ),
                                ),
                              );
                            }
                            if (state.searchResults.isEmpty) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.h),
                                child: Text(
                                  'No results found',
                                  style: TextStyleManger.BlackTitle.copyWith(
                                    color: pallette.muted,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              );
                            }
                            return Column(
                              children: state.searchResults.map((city) {
                                return PopularSearch(
                                  city: city,
                                  pallette: pallette,
                                  onTap: () {
                                    context.read<HomePageBloc>().add(
                                      SelectCityEvent(city),
                                    );
                                    context.pop();
                                  },
                                );
                              }).toList(),
                            );
                          },
                        );
                      },
                    ),

                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Text _buildSectionText(String title, WeatherPalette palette) {
    return Text(
      title,
      style: TextStyleManger.BlackTitle.copyWith(
        fontSize: 14.sp,
        letterSpacing: 2,
        color: palette.muted,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class PopularSearch extends StatelessWidget {
  const PopularSearch({
    super.key,
    required this.pallette,
    required this.city,
    required this.onTap,
  });

  final CitySearchEntity city;
  final WeatherPalette pallette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: Container(
          padding: EdgeInsets.only(bottom: 12.h),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: pallette.foreground, width: 0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      city.name,
                      style: TextStyleManger.BlackTitle.copyWith(
                        color: pallette.foreground,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      city.country,
                      style: TextStyleManger.BlackTitle.copyWith(
                        color: pallette.muted,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                CupertinoIcons.chevron_right,
                color: pallette.muted,
                size: 16.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
