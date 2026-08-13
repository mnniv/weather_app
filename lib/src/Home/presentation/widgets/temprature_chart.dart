import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:weather_app/core/Theming/Fonts/TextStyleManger.dart';
import 'package:weather_app/core/weather/weather_palette.dart';
import 'package:weather_app/core/weather/weather_enum.dart';
import 'package:weather_app/src/Home/presentation/widgets/weather_glass.dart';

class TemperatureChart extends StatefulWidget {
  final List<HourPoint> hours;
  final WeatherPalette palette;

  const TemperatureChart({
    super.key,
    required this.hours,
    required this.palette,
  });

  @override
  State<TemperatureChart> createState() => _TemperatureChartState();
}

class _TemperatureChartState extends State<TemperatureChart>
    with SingleTickerProviderStateMixin {
  static const double chartHeight = 130;
  static const double paddingX = 10;
  static const double paddingY = 18;

  late final AnimationController animationController;

  int selectedIndex = 0;
  bool dragging = false;

  List<HourPoint> get data => widget.hours.take(24).toList();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final chartData = _ChartData.fromHours(
      data,
      chartHeight: chartHeight,
      paddingX: paddingX,
      paddingY: paddingY,
    );

    final safeIndex = min(selectedIndex, data.length - 1);

    final active = data[safeIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(active),
        SizedBox(height: 12.h),

        WeatherGlass(
          palette: widget.palette,
          child: Column(
            children: [
              SizedBox(
                height: 150.h,
                width: double.infinity,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,

                  onTapDown: (details) {
                    _pickIndex(details.localPosition.dx);
                  },

                  onHorizontalDragStart: (details) {
                    dragging = true;

                    _pickIndex(details.localPosition.dx);
                  },

                  onHorizontalDragUpdate: (details) {
                    if (dragging) {
                      _pickIndex(details.localPosition.dx);
                    }
                  },

                  onHorizontalDragEnd: (_) {
                    dragging = false;
                  },

                  onHorizontalDragCancel: () {
                    dragging = false;
                  },

                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (_, __) {
                      return CustomPaint(
                        painter: _TemperatureChartPainter(
                          data: chartData,
                          selectedIndex: safeIndex,
                          progress: animationController.value,
                          color: widget.palette.foreground,
                        ),
                        child: const SizedBox.expand(),
                      );
                    },
                  ),
                ),
              ),

              _buildLabels(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(HourPoint active) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'TEMPERATURE TODAY',
          style: TextStyleManger.BlackTitle.copyWith(
            fontSize: 14.sp,
            letterSpacing: 2,
            color: widget.palette.muted,
            fontWeight: FontWeight.w400,
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${active.temp.round()}°',
              style: TextStyleManger.BlackTitle.copyWith(
                fontSize: 24.sp,
                height: 1,
                color: widget.palette.foreground,
                fontWeight: FontWeight.w300,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              '${active.label} · ${conditionLabel(active.condition)}',
              style: TextStyleManger.BlackTitle.copyWith(
                fontSize: 11.sp,
                color: widget.palette.muted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLabels() {
    const indexes = [0, 6, 12, 18, 23];

    return Padding(
      padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: indexes.map((index) {
          return Text(
            data.length > index ? data[index].label : '',
            style: TextStyleManger.BlackTitle.copyWith(
              fontSize: 10.sp,
              color: widget.palette.muted,
              fontWeight: FontWeight.w400,
            ),
          );
        }).toList(),
      ),
    );
  }

  void _pickIndex(double localX) {
    if (data.length < 2) return;

    final width = context.size?.width ?? 0;

    if (width <= 0) return;

    final chartWidth = width - 24;

    final usableWidth = max(1, chartWidth - paddingX * 2);

    final ratio = ((localX - paddingX) / usableWidth).clamp(0.0, 1.0);

    final index = (ratio * (data.length - 1)).round();

    setState(() {
      selectedIndex = index;
    });
  }
}

/* -------------------------------------------------------------------------- */
/*                               CHART DATA                                   */
/* -------------------------------------------------------------------------- */

class _ChartData {
  final List<Offset> points;
  final String linePath;
  final String areaPath;

  const _ChartData({
    required this.points,
    required this.linePath,
    required this.areaPath,
  });

  factory _ChartData.fromHours(
    List<HourPoint> data, {
    required double chartHeight,
    required double paddingX,
    required double paddingY,
  }) {
    final temperatures = data.map((hour) => hour.temp).toList();

    final minTemp = temperatures.reduce(min);
    final maxTemp = temperatures.reduce(max);

    final span = max(1, maxTemp - minTemp);

    final points = data.asMap().entries.map((entry) {
      final index = entry.key;
      final hour = entry.value;

      final x =
          paddingX + (index / max(1, data.length - 1)) * (320 - paddingX * 2);

      final y =
          paddingY +
          (1 - ((hour.temp - minTemp) / span)) * (chartHeight - paddingY * 2);

      return Offset(x, y);
    }).toList();

    final line = _smoothPath(points);

    final area = points.isEmpty
        ? ''
        : '$line '
              'L ${points.last.dx} $chartHeight '
              'L ${points.first.dx} $chartHeight Z';

    return _ChartData(points: points, linePath: line, areaPath: area);
  }
}

/* -------------------------------------------------------------------------- */
/*                              SMOOTH CURVE                                  */
/* -------------------------------------------------------------------------- */

String _smoothPath(List<Offset> points) {
  if (points.length < 2) {
    return '';
  }

  final buffer = StringBuffer();

  buffer.write('M ${points.first.dx} ${points.first.dy}');

  for (int i = 0; i < points.length - 1; i++) {
    final p0 = i > 0 ? points[i - 1] : points[i];

    final p1 = points[i];

    final p2 = points[i + 1];

    final p3 = i + 2 < points.length ? points[i + 2] : p2;

    final c1x = p1.dx + (p2.dx - p0.dx) / 6;

    final c1y = p1.dy + (p2.dy - p0.dy) / 6;

    final c2x = p2.dx - (p3.dx - p1.dx) / 6;

    final c2y = p2.dy - (p3.dy - p1.dy) / 6;

    buffer.write(
      ' C '
      '$c1x $c1y, '
      '$c2x $c2y, '
      '${p2.dx} ${p2.dy}',
    );
  }

  return buffer.toString();
}

/* -------------------------------------------------------------------------- */
/*                               CHART PAINTER                                */
/* -------------------------------------------------------------------------- */

class _TemperatureChartPainter extends CustomPainter {
  final _ChartData data;
  final int selectedIndex;
  final double progress;
  final Color color;

  const _TemperatureChartPainter({
    required this.data,
    required this.selectedIndex,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.points.length < 2) {
      return;
    }

    final scaleX = size.width / 320;

    canvas.save();

    canvas.scale(scaleX, 1);

    final linePath = _pathFromString(data.linePath);

    final areaPath = _pathFromString(data.areaPath);

    /* ----------------------------- AREA ----------------------------- */

    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [color.withValues(alpha: 0.35), color.withValues(alpha: 0)],
    );

    final areaPaint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, 320, size.height));

    canvas.drawPath(areaPath, areaPaint);

    /* ----------------------------- LINE ----------------------------- */

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final animatedPath = _partialPath(data.points, progress);

    canvas.drawPath(animatedPath, linePaint);

    /* --------------------------- SELECTED --------------------------- */

    final safeIndex = min(selectedIndex, data.points.length - 1);

    final activePoint = data.points[safeIndex];

    final lineX = activePoint.dx;

    final dashedPaint = Paint()
      ..color = color.withValues(alpha: 0.28)
      ..strokeWidth = 1;

    _drawDashedLine(
      canvas,
      Offset(lineX, 7),
      Offset(lineX, size.height),
      dashedPaint,
    );

    /* Glow circle */

    final glowPaint = Paint()..color = color.withValues(alpha: 0.18);

    canvas.drawCircle(activePoint, 11, glowPaint);

    /* Main circle */

    final pointPaint = Paint()..color = color;

    canvas.drawCircle(activePoint, 5, pointPaint);

    canvas.restore();
  }

  Path _pathFromString(String path) {
    // The path is generated from the same points.
    // We don't need SVG parsing in Flutter.
    //
    // This method is replaced by _createSmoothPath
    // below.
    return Path();
  }

  Path _partialPath(List<Offset> points, double progress) {
    final path = _createSmoothPath(points);

    if (progress >= 1) {
      return path;
    }

    final metrics = path.computeMetrics().toList();

    if (metrics.isEmpty) {
      return path;
    }

    final metric = metrics.first;

    return metric.extractPath(0, metric.length * progress);
  }

  Path _createSmoothPath(List<Offset> points) {
    final path = Path();

    if (points.length < 2) {
      return path;
    }

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = i > 0 ? points[i - 1] : points[i];

      final p1 = points[i];

      final p2 = points[i + 1];

      final p3 = i + 2 < points.length ? points[i + 2] : p2;

      final c1x = p1.dx + (p2.dx - p0.dx) / 6;

      final c1y = p1.dy + (p2.dy - p0.dy) / 6;

      final c2x = p2.dx - (p3.dx - p1.dx) / 6;

      final c2y = p2.dy - (p3.dy - p1.dy) / 6;

      path.cubicTo(c1x, c1y, c2x, c2y, p2.dx, p2.dy);
    }

    return path;
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashLength = 3.0;
    const gapLength = 4.0;

    final distance = (end - start).distance;

    final direction = (end - start) / distance;

    double current = 0;

    while (current < distance) {
      final dashStart = start + direction * current;

      final dashEnd = start + direction * min(current + dashLength, distance);

      canvas.drawLine(dashStart, dashEnd, paint);

      current += dashLength + gapLength;
    }
  }

  @override
  bool shouldRepaint(covariant _TemperatureChartPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}

/* -------------------------------------------------------------------------- */
/*                              WEATHER LABEL                                 */
/* -------------------------------------------------------------------------- */

String conditionLabel(WeatherCondition condition) {
  switch (condition) {
    case WeatherCondition.sunny:
      return 'Sunny';

    case WeatherCondition.sunset:
      return 'Sunset';

    case WeatherCondition.cloudy:
      return 'Cloudy';

    case WeatherCondition.rain:
      return 'Rain';

    case WeatherCondition.thunder:
      return 'Thunder';

    case WeatherCondition.snow:
      return 'Snow';

    case WeatherCondition.fog:
      return 'Fog';

    case WeatherCondition.clearNight:
      return 'Clear night';
  }
}

/* -------------------------------------------------------------------------- */
/*                              HOURLY MODEL                                  */
/* -------------------------------------------------------------------------- */

class HourPoint {
  final String label;
  final double temp;
  final WeatherCondition condition;

  const HourPoint({
    required this.label,
    required this.temp,
    required this.condition,
  });
}
