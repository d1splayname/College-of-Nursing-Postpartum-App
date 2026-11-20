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
    final Color text;

    const AppTheme({
        required this.white,
        required this.black,
        required this.background,

        required this.primary,
        required this.secondary,
        required this.tertiary,

        required this.card,
        required this.icon,
        required this.text,
    });
}

const OceanTheme = AppTheme(
    white: Color(0xffffffff),
    black: Color(0xff000000),

    background: LinearGradient( 
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xff95e0e1),
            Color(0xffffeaC2),
        ],
    ),

    // Primary colors (from lighter to darker)    
    primary: Color(0xb3ffffff),     // white with 70% opacity
    secondary: Color(0xfff2e7d0),   // cream
    tertiary: Color (0xff95e0e1),   // teal

    card: Color(0xff1e4d58),        // dark teal
    icon: Color(0xffffffff),        // white
    text: Color(0xff1A2b3c),        // navy
);

const SunriseTheme = AppTheme(
    white: Color(0xffffffff),
    black: Color(0xff000000), 

    background: LinearGradient(     // Pink gradient
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xffd9b8ae),
            Color(0xfff5d3da),
        ],
    ),

    primary: Color(0xb3f3eee8),     // white with 70% opacity
    secondary: Color(0xffd9b8ae),   // Mauve?
    tertiary: Color (0xffd9b8ae),   // Pink?

    card: Color(0xffb08a83),        // Slightly darker mauve
    icon: Color(0xff5e4a48),
    text: Color(0xff000000),        // Black

);

const DesertTheme = AppTheme(
    white: Color(0xffffffff),
    black: Color(0xff000000), 

    background: LinearGradient(     // Orange gradient
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
            Color(0xffcE793a),
            Color(0xfff9cba8),
        ],
    ),

    primary: Color(0xb3e6c96a),     // Mustard with 70% opacity
    secondary: Color(0xffb64b12),   // Rust
    tertiary: Color (0xffce793a),   // Orange

    card: Color(0xFff4c6b3b),        // Dark Sage
    icon: Color(0xff40e0d0),        // Teal
    text: Color(0xff000000),        // Black

);