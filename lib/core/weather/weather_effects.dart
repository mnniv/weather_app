import 'dart:math';

import 'package:flutter/material.dart';
import 'weather_enum.dart';
import 'weather_palette.dart';

class WeatherEffects extends StatelessWidget {
  final WeatherCondition condition;
  final WeatherPalette palette;

  const WeatherEffects({
    super.key,
    required this.condition,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    switch (condition) {
      case WeatherCondition.sunny:
        return const SizedBox.shrink();

      case WeatherCondition.sunset:
        return SunsetEffect(palette: palette);

      case WeatherCondition.cloudy:
        return CloudyEffect(palette: palette);

      case WeatherCondition.rain:
        return RainEffect(palette: palette);

      case WeatherCondition.thunder:
        return ThunderEffect(palette: palette);

      case WeatherCondition.snow:
        return SnowEffect(palette: palette);

      case WeatherCondition.fog:
        return FogEffect(palette: palette);

      case WeatherCondition.clearNight:
        return ClearNightEffect(palette: palette);
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                                    SNOW                                    */
/* -------------------------------------------------------------------------- */

class SnowEffect extends StatefulWidget {
  final WeatherPalette palette;

  const SnowEffect({super.key, required this.palette});

  @override
  State<SnowEffect> createState() => _SnowEffectState();
}

class _SnowEffectState extends State<SnowEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  final Random random = Random();
  final List<_Snowflake> flakes = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    for (int i = 0; i < 70; i++) {
      flakes.add(
        _Snowflake(
          x: random.nextDouble(),
          y: random.nextDouble(),
          size: 2 + random.nextDouble() * 5,
          speed: 0.15 + random.nextDouble() * 0.35,
          drift: random.nextDouble() * 2 * pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return CustomPaint(
            size: Size.infinite,
            painter: _SnowPainter(
              flakes: flakes,
              progress: controller.value,
              color: widget.palette.particle,
            ),
          );
        },
      ),
    );
  }
}

class _Snowflake {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double drift;

  const _Snowflake({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.drift,
  });
}

class _SnowPainter extends CustomPainter {
  final List<_Snowflake> flakes;
  final double progress;
  final Color color;

  const _SnowPainter({
    required this.flakes,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    for (final flake in flakes) {
      final y = ((flake.y + progress * flake.speed) % 1.15) * size.height;

      final drift = sin(progress * 2 * pi + flake.drift) * 18;

      final x = flake.x * size.width + drift;

      canvas.drawCircle(Offset(x, y), flake.size, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SnowPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/* -------------------------------------------------------------------------- */
/*                                  THUNDER                                   */
/* -------------------------------------------------------------------------- */

class ThunderEffect extends StatefulWidget {
  final WeatherPalette palette;

  const ThunderEffect({super.key, required this.palette});

  @override
  State<ThunderEffect> createState() => _ThunderEffectState();
}

class _ThunderEffectState extends State<ThunderEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  bool lightning = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    controller.addListener(_handleLightning);
  }

  void _handleLightning() {
    final value = controller.value;

    final active =
        (value > 0.02 && value < 0.06) ||
        (value > 0.10 && value < 0.14) ||
        (value > 0.20 && value < 0.24);

    if (active != lightning) {
      setState(() {
        lightning = active;
      });
    }
  }

  @override
  void dispose() {
    controller.removeListener(_handleLightning);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        RainEffect(palette: widget.palette),

        AnimatedOpacity(
          opacity: lightning ? 0.55 : 0,
          duration: const Duration(milliseconds: 40),
          child: Container(color: Colors.white),
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   CLOUDY                                   */
/* -------------------------------------------------------------------------- */

class CloudyEffect extends StatefulWidget {
  final WeatherPalette palette;

  const CloudyEffect({super.key, required this.palette});

  @override
  State<CloudyEffect> createState() => _CloudyEffectState();
}

class _CloudyEffectState extends State<CloudyEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Stack(
            children: [
              Positioned(
                top: 60,
                left: -100 + controller.value * 80,
                child: _CloudBlob(
                  color: widget.palette.glow,
                  width: 260,
                  height: 120,
                ),
              ),

              Positioned(
                top: 180,
                right: -120 + controller.value * 60,
                child: _CloudBlob(
                  color: widget.palette.glow2,
                  width: 300,
                  height: 140,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CloudBlob extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const _CloudBlob({
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [BoxShadow(color: color, blurRadius: 60, spreadRadius: 20)],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                    FOG                                     */
/* -------------------------------------------------------------------------- */

class FogEffect extends StatefulWidget {
  final WeatherPalette palette;

  const FogEffect({super.key, required this.palette});

  @override
  State<FogEffect> createState() => _FogEffectState();
}

class _FogEffectState extends State<FogEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Stack(
            children: [
              Positioned(
                top: 120,
                left: -150 + controller.value * 100,
                child: _FogBlob(
                  color: widget.palette.glow,
                  width: 400,
                  height: 100,
                ),
              ),
              Positioned(
                top: 300,
                right: -180 + controller.value * 120,
                child: _FogBlob(
                  color: widget.palette.glow2,
                  width: 450,
                  height: 120,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FogBlob extends StatelessWidget {
  final Color color;
  final double width;
  final double height;

  const _FogBlob({
    required this.color,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100),
        boxShadow: [BoxShadow(color: color, blurRadius: 70, spreadRadius: 30)],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   SUNSET                                   */
/* -------------------------------------------------------------------------- */

class SunsetEffect extends StatefulWidget {
  final WeatherPalette palette;

  const SunsetEffect({super.key, required this.palette});

  @override
  State<SunsetEffect> createState() => _SunsetEffectState();
}

class _SunsetEffectState extends State<SunsetEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final scale = 0.9 + controller.value * 0.15;

          return Stack(
            children: [
              Positioned(
                top: 50,
                right: 20,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.palette.glow,
                      boxShadow: [
                        BoxShadow(
                          color: widget.palette.glow,
                          blurRadius: 80,
                          spreadRadius: 30,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                               CLEAR NIGHT                                 */
/* -------------------------------------------------------------------------- */

class ClearNightEffect extends StatefulWidget {
  final WeatherPalette palette;

  const ClearNightEffect({super.key, required this.palette});

  @override
  State<ClearNightEffect> createState() => _ClearNightEffectState();
}

class _ClearNightEffectState extends State<ClearNightEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  final Random random = Random();
  final List<_Star> stars = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    for (int i = 0; i < 60; i++) {
      stars.add(
        _Star(
          x: random.nextDouble(),
          y: random.nextDouble() * 0.7,
          size: 0.8 + random.nextDouble() * 2,
          phase: random.nextDouble() * 2 * pi,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return CustomPaint(
            size: Size.infinite,
            painter: _StarsPainter(
              stars: stars,
              progress: controller.value,
              color: widget.palette.particle,
            ),
          );
        },
      ),
    );
  }
}

class _Star {
  final double x;
  final double y;
  final double size;
  final double phase;

  const _Star({
    required this.x,
    required this.y,
    required this.size,
    required this.phase,
  });
}

class _StarsPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;
  final Color color;

  const _StarsPainter({
    required this.stars,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final opacity =
          0.35 + ((sin(progress * 2 * pi + star.phase) + 1) / 2) * 0.65;

      final paint = Paint()..color = color.withValues(alpha: opacity);

      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class RainEffect extends StatefulWidget {
  final WeatherPalette palette;

  const RainEffect({super.key, required this.palette});

  @override
  State<RainEffect> createState() => _RainEffectState();
}

class _RainEffectState extends State<RainEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  final Random random = Random();

  final List<_RainDrop> drops = [];

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    for (int i = 0; i < 70; i++) {
      drops.add(
        _RainDrop(
          x: random.nextDouble(),
          y: random.nextDouble(),
          length: 12 + random.nextDouble() * 20,
          speed: 0.4 + random.nextDouble() * 0.8,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RainPainter(
              drops: drops,
              progress: controller.value,
              color: widget.palette.particle,
            ),
            size: Size.infinite,
          );
        },
      ),
    );
  }
}

class _RainDrop {
  final double x;
  final double y;
  final double length;
  final double speed;

  const _RainDrop({
    required this.x,
    required this.y,
    required this.length,
    required this.speed,
  });
}

class _RainPainter extends CustomPainter {
  final List<_RainDrop> drops;
  final double progress;
  final Color color;

  const _RainPainter({
    required this.drops,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (final drop in drops) {
      final y = ((drop.y + progress * drop.speed) % 1.2) * size.height;

      final x = drop.x * size.width;

      canvas.drawLine(Offset(x, y), Offset(x - 5, y + drop.length), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RainPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
