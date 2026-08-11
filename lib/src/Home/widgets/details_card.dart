import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import 'package:weather_app/src/Home/widgets/weather_glass.dart';

class DetailsCard extends StatelessWidget {
  final WeatherPalette palette;

  const DetailsCard({super.key, required this.palette});

  @override
  Widget build(BuildContext context) {
    return WeatherGlass(
      palette: palette,

      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 20.w),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  CupertinoIcons.wind,
                  color: palette.foreground,
                  size: 26.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  'WIND',
                  style: TextStyleManger.BlackTitle.copyWith(
                    fontSize: 16.sp,
                    color: palette.foreground,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
            Text(
              '18 km/h',
              style: TextStyleManger.BlackTitle.copyWith(
                color: palette.foreground,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15.h),
            SizedBox(
              width: 100.w,
              child: LinearProgressIndicator(
                value: 0.4,
                color: palette.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
