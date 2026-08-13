import 'package:flutter/material.dart';
import 'package:weather_app/core/weather/weather_palette.dart';

class WeatherGlass extends StatelessWidget {
  final Widget child;
  final WeatherPalette palette;

  const WeatherGlass({super.key, required this.child, required this.palette});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: palette.glass,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: palette.glassBorder),
      ),
      child: child,
    );
  }
}
