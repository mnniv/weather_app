import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import 'package:weather_app/src/Home/presentation/widgets/weather_glass.dart';

class DetailsCard extends StatelessWidget {
  final WeatherPalette palette;
  final String title;
  final String value;
  final IconData icon;
  final double? progress; // 0.0–1.0, null hides the bar

  const DetailsCard({
    super.key,
    required this.palette,
    required this.title,
    required this.value,
    required this.icon,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return WeatherGlass(
      palette: palette,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: palette.foreground, size: 26.sp),
                SizedBox(width: 10.w),
                Text(
                  title,
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
              value,
              style: TextStyleManger.BlackTitle.copyWith(
                color: palette.foreground,
                fontSize: 22.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (progress != null) ...[
              SizedBox(height: 15.h),
              SizedBox(
                width: 100.w,
                child: LinearProgressIndicator(
                  value: progress!.clamp(0.0, 1.0),
                  color: palette.foreground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}