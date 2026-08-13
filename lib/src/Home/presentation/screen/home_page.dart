import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_background.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_bloc.dart';
import 'package:weather_app/src/Home/presentation/bloc/home_state.dart';
import 'package:weather_app/src/Home/presentation/widgets/details_card.dart';
import 'package:weather_app/src/Home/presentation/widgets/header.dart';
import 'package:weather_app/src/Home/presentation/widgets/hourly_forecast.dart';
import 'package:weather_app/src/Home/presentation/widgets/outlook_day.dart';
import 'package:weather_app/src/Home/presentation/widgets/temprature_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomeState>(
      builder: (context, state) {
        if (state.status == HomeStatus.loading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == HomeStatus.failure) {
          return Scaffold(
            body: Center(
              child: Text(state.errorMessage ?? 'Something went wrong'),
            ),
          );
        }

        if (state.weather == null) {
          return const Scaffold(body: Center(child: Text('No weather data')));
        }

        final weather = state.weather!;
        final condition = weather.current.condition;
        final palette = weatherPalettes[condition]!;
        final currentHourIndex = _currentHourIndex(weather.hourly);
        final upcomingHours = weather.hourly.sublist(currentHourIndex);
        final weekMinTemp = weather.daily
            .map((d) => d.minTemperature)
            .reduce((a, b) => a < b ? a : b);
        final weekMaxTemp = weather.daily
            .map((d) => d.maxTemperature)
            .reduce((a, b) => a > b ? a : b);

        return WeatherBackground(
          condition: condition,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Header(
                        palette: palette,
                        locationName: weather.location.name,
                        dateTime: weather.current.lastUpdated,
                      ),

                      SizedBox(height: 20.h),
                      Text(
                        '${weather.current.temperature.round()}°',
                        style: TextStyleManger.BlackTitle.copyWith(
                          fontSize: 100.sp,
                          color: palette.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Text(
                        weather.current.conditionText,
                        style: TextStyleManger.BlackTitle.copyWith(
                          fontSize: 20.sp,
                          color: palette.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      Text(
                        'Feels like ${weather.current.feelsLike.round()}°',
                        style: TextStyleManger.BlackTitle.copyWith(
                          fontSize: 18.sp,
                          color: palette.foreground,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      Text(
                        weather.current.description,
                        style: TextStyleManger.BlackTitle.copyWith(
                          fontSize: 18.sp,
                          color: palette.muted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 40.h),

                      _buildSectionText('HOURLY FORECAST', palette),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 160.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: weather.hourly.length,
                          itemBuilder: (context, index) {
                            final hour = upcomingHours[index];
                            return HourlyForecast(
                              palette: palette,
                              label: index == 0 ? 'Now' : hour.label,
                              temperature: hour.temperature,
                              condition: hour.condition,
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 40.h),

                      TemperatureChart(
                        palette: palette,
                        hours: upcomingHours.asMap().entries.map((entry) {
                          return HourPoint(
                            label: entry.key == 0 ? 'Now' : entry.value.label,
                            temp: entry.value.temperature,
                            condition: entry.value.condition,
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20.h),

                      _buildSectionText('7-DAY OUTLOOK', palette),
                      SizedBox(height: 20.h),

                      ...weather.daily.map(
                        (day) => OutlookDay(
                          palette: palette,
                          label: day.label,
                          conditionText: day.conditionText,
                          condition: day.condition,
                          minTemp: day.minTemperature,
                          maxTemp: day.maxTemperature,
                          weekMinTemp: weekMinTemp,
                          weekMaxTemp: weekMaxTemp,
                        ),
                      ),
                      SizedBox(height: 20.h),

                      _buildSectionText('DETAILS', palette),
                      SizedBox(height: 20.h),

                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200.w,
                          childAspectRatio: 1.1,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                        ),
                        itemCount: _detailItems(weather.current).length,
                        itemBuilder: (context, index) {
                          final item = _detailItems(weather.current)[index];
                          return DetailsCard(
                            palette: palette,
                            title: item.title,
                            value: item.value,
                            icon: item.icon,
                            progress: item.progress,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<_DetailItem> _detailItems(dynamic current) {
    return [
      _DetailItem(
        'UV Index',
        current.uvIndex.toStringAsFixed(0),
        CupertinoIcons.sun_max,
        progress: (current.uvIndex / 11.0).clamp(0.0, 1.0),
      ),
      _DetailItem(
        'Wind',
        '${current.windSpeed.round()} km/h',
        CupertinoIcons.wind,
        progress: (current.windSpeed / 60.0).clamp(0.0, 1.0),
      ),
      _DetailItem(
        'Humidity',
        '${current.humidity}%',
        CupertinoIcons.drop,
        progress: (current.humidity / 100.0).clamp(0.0, 1.0),
      ),
      _DetailItem(
        'Visibility',
        '${current.visibility.round()} km',
        CupertinoIcons.eye,
        progress: (current.visibility / 10.0).clamp(0.0, 1.0),
      ),
      _DetailItem(
        'Pressure',
        '${current.pressure.round()} hPa',
        CupertinoIcons.gauge,
      ),
      _DetailItem(
        'Feels Like',
        '${current.feelsLike.round()}°',
        CupertinoIcons.thermometer,
      ),
    ];
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

  int _currentHourIndex(List hourlyList) {
    if (hourlyList.isEmpty) return 0;
    final now = DateTime.now();

    var closestIndex = 0;
    var smallestDiff = (hourlyList[0].time as DateTime).difference(now).abs();

    for (int i = 1; i < hourlyList.length; i++) {
      final diff = (hourlyList[i].time as DateTime).difference(now).abs();
      if (diff < smallestDiff) {
        smallestDiff = diff;
        closestIndex = i;
      }
    }
    return closestIndex;
  }
}

class _DetailItem {
  final String title;
  final String value;
  final IconData icon;
  final double? progress;
  _DetailItem(this.title, this.value, this.icon, {this.progress});
}
