import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import '../../../../core/Theming/Colors/colors.dart';

class Header extends StatelessWidget {
  final WeatherPalette palette;
  final String locationName;
  final DateTime dateTime;

  const Header({
    super.key,
    required this.palette,
    required this.locationName,
    required this.dateTime,
  });

  static const _weekdays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday',
    'Friday', 'Saturday', 'Sunday',
  ];

  static const _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  String get _formattedDate {
    final weekday = _weekdays[dateTime.weekday - 1];
    final month = _months[dateTime.month - 1];
    return '$weekday, $month ${dateTime.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              locationName,
              style: TextStyleManger.BlackTitle.copyWith(
                fontSize: 25.sp,
                color: palette.foreground,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              _formattedDate,
              style: TextStyleManger.BlackTitle.copyWith(
                fontSize: 15.sp,
                color: palette.muted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.card),
              ),
              child: Icon(
                CupertinoIcons.moon,
                size: 22.sp,
                color: palette.foreground,
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.card),
              ),
              child: Icon(
                CupertinoIcons.search,
                size: 22.sp,
                color: palette.foreground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}