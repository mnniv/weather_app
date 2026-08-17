import 'package:flutter/material.dart';
import 'package:weather_app/core/weather/weather_effects.dart';
import 'package:weather_app/core/weather/weather_enum.dart';
import 'weather_palette.dart';

class WeatherBackground extends StatelessWidget {
  final WeatherCondition condition;
  final Widget child;

  const WeatherBackground({
    super.key,
    required this.condition,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final palette = weatherPalettes[condition]!;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: palette.stops,
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            _Glow(color: palette.glow, alignment: Alignment.topRight),
        
            _Glow(color: palette.glow2, alignment: Alignment.centerLeft),
        
            WeatherEffects(condition: condition, palette: palette),
        
            child,
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final Alignment alignment;

  const _Glow({required this.color, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            boxShadow: [
              BoxShadow(color: color, blurRadius: 100, spreadRadius: 40),
            ],
          ),
        ),
      ),
    );
  }
}
