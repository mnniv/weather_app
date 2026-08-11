import 'package:flutter/material.dart';
import 'weather_enum.dart';

enum SceneInk { light, dark }

class WeatherPalette {
  final List<Color> stops;

  final Color glow;
  final Color glow2;

  final Color foreground;
  final Color muted;

  final Color glass;
  final Color glassBorder;

  final Color particle;

  final SceneInk ink;

  const WeatherPalette({
    required this.stops,
    required this.glow,
    required this.glow2,
    required this.foreground,
    required this.muted,
    required this.glass,
    required this.glassBorder,
    required this.particle,
    required this.ink,
  });
}

/*
  Weather palettes translated from your web design.

  Each condition contains:

  stops        -> background gradient
  glow         -> main glow
  glow2        -> secondary glow
  foreground   -> main text/icon color
  muted        -> secondary text color
  glass        -> glass card background
  glassBorder  -> glass card border
  particle     -> rain/snow/light particles
  ink          -> whether the UI should use light/dark text
*/

const Map<WeatherCondition, WeatherPalette> weatherPalettes = {
  // ============================================================
  // SUNNY
  // ============================================================
  WeatherCondition.sunny: WeatherPalette(
    stops: [Color(0xFF9FD8EC), Color(0xFFB9DFF0), Color(0xFFF6E4A9)],

    glow: Color(0xBFFFE49A),
    glow2: Color(0x80A8DDF5),

    foreground: Color(0xFF364A60),
    muted: Color(0x9E364A60),

    glass: Color(0x57FFFFFF),
    glassBorder: Color(0x80FFFFFF),

    particle: Color(0xD9FFF2A6),

    ink: SceneInk.dark,
  ),

  // ============================================================
  // SUNSET
  // ============================================================
  WeatherCondition.sunset: WeatherPalette(
    stops: [Color(0xFF9065D0), Color(0xFFFF7F6C), Color(0xFFFFC577)],

    glow: Color(0xBFFF9E70),
    glow2: Color(0x99905ACD),

    foreground: Color(0xFFFFF8E8),
    muted: Color(0xB3FFF8E8),

    glass: Color(0x29FFFFFF),
    glassBorder: Color(0x47FFFFFF),

    particle: Color(0xB3FFE3A0),

    ink: SceneInk.light,
  ),

  // ============================================================
  // CLOUDY
  // ============================================================
  WeatherCondition.cloudy: WeatherPalette(
    stops: [Color(0xFF96A7B7), Color(0xFFBCC9D3), Color(0xFFD8DFE4)],

    glow: Color(0x99F2F5F7),
    glow2: Color(0x80AEBCC8),

    foreground: Color(0xFF454E5A),
    muted: Color(0x9E454E5A),

    glass: Color(0x5CFFFFFF),
    glassBorder: Color(0x80FFFFFF),

    particle: Color(0x99FFFFFF),

    ink: SceneInk.dark,
  ),

  // ============================================================
  // RAIN
  // ============================================================
  WeatherCondition.rain: WeatherPalette(
    stops: [Color(0xFF3C4F62), Color(0xFF5E7488), Color(0xFF8295A3)],

    glow: Color(0x6689B5D1),
    glow2: Color(0x80556C8C),

    foreground: Color(0xFFF7FAFC),
    muted: Color(0xB3F7FAFC),

    glass: Color(0x24FFFFFF),
    glassBorder: Color(0x3DFFFFFF),

    particle: Color(0x8CDCE9F2),

    ink: SceneInk.light,
  ),

  // ============================================================
  // THUNDER
  // ============================================================
  WeatherCondition.thunder: WeatherPalette(
    stops: [Color(0xFF161F32), Color(0xFF29354F), Color(0xFF404E63)],

    glow: Color(0x73A18DFF),
    glow2: Color(0x99505A99),

    foreground: Color(0xFFF7F9FC),
    muted: Color(0xADF7F9FC),

    glass: Color(0x1FFFFFFF),
    glassBorder: Color(0x33FFFFFF),

    particle: Color(0x8CD9E2F0),

    ink: SceneInk.light,
  ),

  // ============================================================
  // SNOW
  // ============================================================
  WeatherCondition.snow: WeatherPalette(
    stops: [Color(0xFF99BDD3), Color(0xFFC4DCE8), Color(0xFFEBF3F7)],

    glow: Color(0xB3F7FCFF),
    glow2: Color(0x80B9D5E8),

    foreground: Color(0xFF465A6C),
    muted: Color(0x9E465A6C),

    glass: Color(0x66FFFFFF),
    glassBorder: Color(0x8CFFFFFF),

    particle: Color(0xE6FFFFFF),

    ink: SceneInk.dark,
  ),

  // ============================================================
  // FOG
  // ============================================================
  WeatherCondition.fog: WeatherPalette(
    stops: [Color(0xFF999FA4), Color(0xFFB9BFC2), Color(0xFFD4D8DB)],

    glow: Color(0x8CF0F2F4),
    glow2: Color(0x80B8BEC3),

    foreground: Color(0xFF48515A),
    muted: Color(0x9948515A),

    glass: Color(0x52FFFFFF),
    glassBorder: Color(0x73FFFFFF),

    particle: Color(0x80FFFFFF),

    ink: SceneInk.dark,
  ),

  // ============================================================
  // CLEAR NIGHT
  // ============================================================
  WeatherCondition.clearNight: WeatherPalette(
    stops: [Color(0xFF181439), Color(0xFF242A50), Color(0xFF3A4C73)],

    glow: Color(0x66A0A4FF),
    glow2: Color(0x806060A8),

    foreground: Color(0xFFF7F5FF),
    muted: Color(0xADF7F5FF),

    glass: Color(0x1FFFFFFF),
    glassBorder: Color(0x33FFFFFF),

    particle: Color(0xE6F5F1FF),

    ink: SceneInk.light,
  ),
};
