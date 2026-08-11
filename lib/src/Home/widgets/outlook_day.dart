import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_palette.dart';

class OutlookDay extends StatelessWidget {
  final WeatherPalette palette;
  const OutlookDay({super.key, required this.palette});

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
                CupertinoIcons.sun_max,
                size: 30.sp,

                color: palette.foreground,
              ),
              SizedBox(width: 10.w),
              Column(
                children: [
                  Text(
                    'Today',
                    style: TextStyleManger.BlackTitle.copyWith(
                      fontSize: 16.sp,
                      color: palette.foreground,

                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Sunny',
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
                '31°',
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
                  value: 0.4,
                  color: palette.foreground,
                ),
              ),
              SizedBox(width: 10.w),

              Text(
                '42°',
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
