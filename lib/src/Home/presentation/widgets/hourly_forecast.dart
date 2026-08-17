import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_enum.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import 'package:weather_app/src/Home/presentation/widgets/weather_glass.dart';

class HourlyForecast extends StatelessWidget {
  final WeatherPalette palette;
  final String label;
  final double temperature;
  final WeatherCondition condition;
  const HourlyForecast({
    super.key,
    required this.palette,
    required this.label,
    required this.temperature,
    required this.condition,
  });

  IconData get _icon {
  switch (condition) {
    case WeatherCondition.sunny:
      return CupertinoIcons.sun_max;
    case WeatherCondition.sunset:
      return CupertinoIcons.sunset;
    case WeatherCondition.cloudy:
      return CupertinoIcons.cloud;
    case WeatherCondition.rain:
      return CupertinoIcons.cloud_rain;
    case WeatherCondition.thunder:
      return CupertinoIcons.cloud_bolt_rain;
    case WeatherCondition.snow:
      return CupertinoIcons.snow;
    case WeatherCondition.fog:
      return CupertinoIcons.cloud_fog;
    case WeatherCondition.clearNight:
      return CupertinoIcons.moon_stars;
  }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: WeatherGlass(
        palette: palette,
        child: Container(
          width: 120.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              Text(
                label,
                style: TextStyleManger.BlackTitle.copyWith(
                  fontSize: 18.sp,
                  color: palette.foreground,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10.h),
              Icon(
                _icon,
                size: 24.sp,
                color: palette.foreground,
              ),
              SizedBox(height: 10.h),
              Text(
                '${temperature.round()}°',
                style: TextStyleManger.BlackTitle.copyWith(
                  fontSize: 28.sp,
                  color: palette.foreground,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}