import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_background.dart';
import 'package:weather_app/core/weather/weather_enum.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import 'package:weather_app/src/Home/widgets/details_card.dart';
import 'package:weather_app/src/Home/widgets/header.dart';
import 'package:weather_app/src/Home/widgets/hourly_forecast.dart';
import 'package:weather_app/src/Home/widgets/outlook_day.dart';
import 'package:weather_app/src/Home/widgets/temprature_chart.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final condition = WeatherCondition.sunny;
    final palette = weatherPalettes[condition]!;

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
                  Header(palette: palette),

                  SizedBox(height: 20.h),
                  Text(
                    '40°',
                    style: TextStyleManger.BlackTitle.copyWith(
                      fontSize: 100.sp,
                      color: palette.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Text(
                    'Sunny',
                    style: TextStyleManger.BlackTitle.copyWith(
                      fontSize: 20.sp,
                      color: palette.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Text(
                    'Feels like 40°',
                    style: TextStyleManger.BlackTitle.copyWith(
                      fontSize: 18.sp,
                      color: palette.foreground,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Text(
                    'Clear skies and warm light all afternoon',
                    style: TextStyleManger.BlackTitle.copyWith(
                      fontSize: 18.sp,
                      color: palette.muted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  _buildSectionText('HOURLY FORECAST', palette),
                  SizedBox(height: 20.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        HourlyForecast(palette: palette),
                        HourlyForecast(palette: palette),
                        HourlyForecast(palette: palette),
                        HourlyForecast(palette: palette),
                        HourlyForecast(palette: palette),
                        HourlyForecast(palette: palette),
                        HourlyForecast(palette: palette),
                      ],
                    ),
                  ),
                  SizedBox(height: 40.h),

                  /// chart here
                  TemperatureChart(
                    palette: palette,
                    hours: const [
                      HourPoint(
                        label: 'Now',
                        temp: 40,
                        condition: WeatherCondition.sunny,
                      ),
                      HourPoint(
                        label: '1PM',
                        temp: 41,
                        condition: WeatherCondition.sunny,
                      ),
                      HourPoint(
                        label: '2PM',
                        temp: 42,
                        condition: WeatherCondition.sunny,
                      ),
                      HourPoint(
                        label: '3PM',
                        temp: 41,
                        condition: WeatherCondition.sunny,
                      ),
                      HourPoint(
                        label: '4PM',
                        temp: 40,
                        condition: WeatherCondition.sunny,
                      ),
                      HourPoint(
                        label: '5PM',
                        temp: 39,
                        condition: WeatherCondition.sunny,
                      ),
                      HourPoint(
                        label: '6PM',
                        temp: 37,
                        condition: WeatherCondition.sunset,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  _buildSectionText('7-DAY OUTLOOK', palette),
                  SizedBox(height: 20.h),

                  OutlookDay(palette: palette),
                  OutlookDay(palette: palette),
                  OutlookDay(palette: palette),
                  OutlookDay(palette: palette),
                  OutlookDay(palette: palette),
                  SizedBox(height: 20.h),

                  _buildSectionText('DETAILS', palette),
                  SizedBox(height: 20.h),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.w,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                    ),
                    itemCount: 7,
                    itemBuilder: (context, index) =>
                        DetailsCard(palette: palette),
                  ),
                ],
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
