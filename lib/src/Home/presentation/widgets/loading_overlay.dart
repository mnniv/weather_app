import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:weather_app/core/Theming/Colors/colors.dart';
import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_background.dart';
import 'package:weather_app/core/weather/weather_enum.dart';
import 'package:weather_app/core/weather/weather_palette.dart';

class WeatherStateView extends StatelessWidget {
  final WeatherCondition condition;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? action;
  final bool animate;

  const WeatherStateView({
    super.key,
    required this.condition,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.action,
    this.animate = true,
  });

  @override
  Widget build(BuildContext context) {
    final palette = weatherPalettes[condition]!;

    return WeatherBackground(
      condition: condition,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              // Atmospheric blur over the weather scene
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(color: Colors.black.withValues(alpha: 0.08)),
                ),
              ),

              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _WeatherGlassIcon(
                        icon: icon,
                        color: iconColor,
                        animate: animate,
                      ),

                      SizedBox(height: 28.h),

                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyleManger.BlackTitle.copyWith(
                          fontSize: 24.sp,
                          color: palette.foreground,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 10.h),

                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyleManger.BlackTitle.copyWith(
                          fontSize: 15.sp,
                          color: palette.muted,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),

                      if (action != null) ...[SizedBox(height: 30.h), action!],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeatherGlassIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final bool animate;

  const _WeatherGlassIcon({
    required this.icon,
    required this.color,
    this.animate = true,
  });

  @override
  State<_WeatherGlassIcon> createState() => _WeatherGlassIconState();
}

class _WeatherGlassIconState extends State<_WeatherGlassIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = widget.animate ? 0.97 + (_controller.value * 0.06) : 1.0;

        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        width: 112.w,
        height: 112.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Your glass
          color: AppColors.glass,
          border: Border.all(
            color: AppColors.card.withValues(alpha: 0.65),
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.16),
              blurRadius: 35,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          // child: Image.asset(
          //   'assets/img/logo.jpg',
          //   width: 200.w,
          //   height: 200.h,
          // ),
          child: Icon(CupertinoIcons.cloud_drizzle, size: 50.sp),
        ),
      ),
    );
  }
}

class WeatherRetryButton extends StatelessWidget {
  final VoidCallback onPressed;

  const WeatherRetryButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColors.glass.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(color: AppColors.card.withValues(alpha: 0.7)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.arrow_clockwise,
                size: 18.sp,
                color: Colors.white,
              ),

              SizedBox(width: 9.w),

              Text(
                'Try Again',
                style: TextStyleManger.BlackTitle.copyWith(
                  fontSize: 15.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
