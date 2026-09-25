import 'package:flutter/material.dart';

class AppTheme {
    final Color primary;
    final Color secondary;
    final Color tertiary;
    final Gradient background;
    final Color card;
    final Color text;
    final Color icon;

    const AppTheme({
        required this.primary,
        required this.secondary,
        required this.tertiary,
        required this.background,
        required this.card,
        required this.text,
        required this.icon,

    });
}

const OceanTheme = AppTheme(
    primary: Color(0xFFf7f4ed),     // Cream
    secondary: Color(0xFF84B3C3),   // Light blue

    tertiary: Color (0xFF16587B),   // Dark blue
    background: LinearGradient(     // Dark blue gradient
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xFF16587B),
            Color(0xFF2697D3),
        ],
    ),

    card: Color(0xFFFAE18E),        // Yellow
    text: Color(0xFF000000),        // Black
    icon: Color(0xFFFFD95C),        // Yellow

);

const SunriseTheme = AppTheme(
    primary: Color(0xFFF3EEE8),     // White
    secondary: Color(0xFFD9B8AE),   // Mauve

    tertiary: Color (0xFFD9B8AE),   // Pink
    background: LinearGradient(     // Pink gradient
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xFFD9B8AE),
            Color(0xFFF5D3DA),
        ],
    ),

    card: Color(0xFFB08A83),        // Slightly darker mauve
    text: Color(0xFF5E4A48),        // Cocoa
    icon: Color(0xFFE89184),        // Rose

);

const DesertTheme = AppTheme(
    primary: Color(0xFFE6C96A),     // Mustard
    secondary: Color(0xFFB64B12),   // Rust

    tertiary: Color (0xFFCE793A),   // Orange
    background: LinearGradient(     // Orange gradient
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xFFCE793A),
            Color(0xFFF9CBA8),
        ],
    ),

    card: Color(0xFF9AA992),        // Sage
    text: Color(0xFF000000),        // Black
    icon: Color(0xFF40E0D0),        // Turquoise

);