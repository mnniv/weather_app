import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import 'package:weather_app/src/Home/widgets/weather_glass.dart';

class HourlyForecast extends StatelessWidget {
  final WeatherPalette palette;
  const HourlyForecast({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12.w),
      child: WeatherGlass(
        palette: palette,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),

          child: Column(
            children: [
              Text(
                'Now',
                style: TextStyleManger.BlackTitle.copyWith(
                  fontSize: 18.sp,
                  color: palette.foreground,

                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 10.h),
              Icon(
                CupertinoIcons.sun_max,
                size: 24.sp,
                color: palette.foreground,
              ),
              SizedBox(height: 10.h),

              Text(
                '40°',
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
