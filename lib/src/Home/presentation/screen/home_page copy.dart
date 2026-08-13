import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_app/core/Theming/Colors/colors.dart';

class HomePageEmpty extends StatelessWidget {
  const HomePageEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGray,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('El Oued , Algeria'),
                        Text('Tuesday, August 11'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(CupertinoIcons.moon),
                        Icon(CupertinoIcons.search),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 20.h),
                Text('40°'),
                SizedBox(height: 20.h),

                Text('Sunny'),
                Text('Feels like 40°'),
                Text('Clear skies and warm light all afternoon'),

                Text('HOURLY FORECAST'),

                Container(
                  child: Column(
                    children: [
                      Text('Now'),
                      Icon(CupertinoIcons.sun_dust),
                      Text('40°'),
                    ],
                  ),
                ),
                Row(
                  children: [
                    SizedBox(width: 48.w),
                    Text('40°'),
                  ],
                ),
                Row(children: [Text('Temperature today'), Text('12PM-Sunny')]),

                /// chart here
                Container(child: Text('Chart here')),
                Text('7-DAY OUTLOOK'),
                Row(
                  children: [
                    Icon(CupertinoIcons.sun_dust),
                    Column(children: [Text('Today'), Text('Sunny')]),

                    Text('31°'),
                    Expanded(child: LinearProgressIndicator()),
                    Text('42°'),
                  ],
                ),
                Text('Details'),
                Container(
                  child: Column(
                    children: [
                      Row(children: [Icon(CupertinoIcons.wind), Text('Wind')]),
                      Text('18 km/h'),
                      LinearProgressIndicator(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
