import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_enum.dart';
import 'package:weather_app/core/weather/weather_palette.dart';

class OutlookDay extends StatelessWidget {
  final WeatherPalette palette;
  final String label;
  final String conditionText;
  final WeatherCondition condition;
  final double minTemp;
  final double maxTemp;
  final double weekMinTemp;
  final double weekMaxTemp;

  const OutlookDay({
    super.key,
    required this.palette,
    required this.label,
    required this.conditionText,
    required this.condition,
    required this.minTemp,
    required this.maxTemp,
    required this.weekMinTemp,
    required this.weekMaxTemp,
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

  double get _progressValue {
    final range = weekMaxTemp - weekMinTemp;
    if (range <= 0) return 1.0;
    return ((maxTemp - weekMinTemp) / range).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _icon,
                size: 30.sp,
                color: palette.foreground,
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyleManger.BlackTitle.copyWith(
                      fontSize: 16.sp,
                      color: palette.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    conditionText,
                    style: TextStyleManger.BlackTitle.copyWith(
                      fontSize: 14.sp,
                      color: palette.muted,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '${minTemp.round()}°',
                style: TextStyleManger.BlackTitle.copyWith(
                  fontSize: 18.sp,
                  color: palette.muted,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 100.w,
                child: LinearProgressIndicator(
                  value: _progressValue,
                  color: palette.foreground,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                '${maxTemp.round()}°',
                style: TextStyleManger.BlackTitle.copyWith(
                  fontSize: 18.sp,
                  color: palette.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}