import 'dart:math';
import 'package:flutter/material.dart';

/// Matrix Rain Effect Painter
/// 
/// Creates a falling matrix-style animation with customizable characters
class MatrixRainPainter extends CustomPainter {
  final double progress;
  final Random _random = Random();

  MatrixRainPainter({required this.progress});

  static const String _chars = '01アカサタナハマヤ0123456789';

  @override
  void paint(Canvas canvas, Size size) {
    for (double x = 0; x < size.width; x += 18) {
      final int dropLength = _random.nextInt(18) + 6;

      for (int i = 0; i < dropLength; i++) {
        final double y =
            ((progress * size.height * 1.5) + i * 18) % size.height;

        final Color charColor = i == 0
            ? Colors.white
            : Colors.greenAccent.withOpacity(0.6);

        final textPainter = TextPainter(
          text: TextSpan(
            text: _chars[_random.nextInt(_chars.length)],
            style: TextStyle(fontSize: 14, color: charColor),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        textPainter.paint(canvas, Offset(x, y));
      }
    }
  }

  @override
  bool shouldRepaint(covariant MatrixRainPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
