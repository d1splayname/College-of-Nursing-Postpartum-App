import 'package:flutter/material.dart';

class AppTheme {
    final Color white;
    final Color black;
    final Gradient background;

    final Color primary;
    final Color secondary;
    final Color tertiary;

    final Color card;
    final Color icon;

    const AppTheme({
        required this.white,
        required this.black,
        required this.background,

        required this.primary,
        required this.secondary,
        required this.tertiary,

        required this.card,
        required this.icon,
    });
}

const OceanTheme = AppTheme(
    white: Color(0xffffffff),
    black: Color(0xff000000),

    background: LinearGradient( 
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xFF16587B),
            Color(0xFF2697D3),
        ],
    ),

    // Primary colors (from lighter to darker)    
    primary: Color(0xFFf7f4ed),     // Cream
    secondary: Color(0xFF84B3C3),   // Light blue
    tertiary: Color (0xFF16587B),   // Dark blue

    card: Color(0xFFFAE18E),        // Yellow
    icon: Color(0xFFFFD95C),        // Yellow

);

const SunriseTheme = AppTheme(
    white: Color(0xff000000), // Swapped because the pink background is light
    black: Color(0xffffffff), 

    background: LinearGradient(     // Pink gradient
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xFFD9B8AE),
            Color(0xFFF5D3DA),
        ],
    ),

    primary: Color(0xFFF3EEE8),     // White
    secondary: Color(0xFFD9B8AE),   // Mauve
    tertiary: Color (0xFFD9B8AE),   // Pink

    card: Color(0xFFB08A83),        // Slightly darker mauve
    icon: Color(0xFF5E4A48),        // Cocoa

);

const DesertTheme = AppTheme(
    white: Color(0xffffffff),
    black: Color(0xff000000), 

    background: LinearGradient(     // Orange gradient
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xFFCE793A),
            Color(0xFFF9CBA8),
        ],
    ),

    primary: Color(0xFFE6C96A),     // Mustard
    secondary: Color(0xFFB64B12),   // Rust
    tertiary: Color (0xFFCE793A),   // Orange

    card: Color(0xFF9AA992),        // Sage
    icon: Color(0xFF40E0D0),        // Turquoise

);