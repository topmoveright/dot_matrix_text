import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DotMatrixPainter extends CustomPainter {
  final TextPainter textPainter;
  final ui.Image textImage;
  final Uint32List pixels;
  final double ledSize;
  final double ledSpacing;
  final Color textColor;
  final Color blankLedColor;
  final int verticalDots;
  final int horizontalDots;
  final bool mirrorMode;
  final bool flickerMode;
  final bool flickerState;
  final bool invertColors;
  final Alignment alignment;

  DotMatrixPainter({
    required this.textPainter,
    required this.textImage,
    required ByteData imageByteData,
    required this.ledSize,
    required this.ledSpacing,
    required this.textColor,
    required this.blankLedColor,
    required this.verticalDots,
    required this.horizontalDots,
    required this.mirrorMode,
    required this.flickerMode,
    required this.flickerState,
    required this.invertColors,
    required this.alignment,
  }) : pixels = imageByteData.buffer.asUint32List();

  @override
  void paint(Canvas canvas, Size size) {
    final dotRadius = ledSize / 2;
    final cellSize = ledSize + ledSpacing;
    final textWidth = textImage.width.toDouble();
    final textHeight = textImage.height.toDouble();

    // Calculate the offset based on alignment
    final dx = ((size.width - textPainter.width) / 2) * (1 + alignment.x);
    final dy = ((size.height - textPainter.height) / 2) * alignment.y;

    // Draw blank LEDs
    _drawBlankLEDs(canvas, dotRadius, cellSize);

    // Draw text LEDs
    _drawTextLEDs(canvas, dotRadius, cellSize, textWidth, textHeight, dx, dy);
  }

  /// Draws the blank LEDs on the canvas
  void _drawBlankLEDs(Canvas canvas, double dotRadius, double cellSize) {
    final paint = Paint()
      ..color = ((flickerMode && flickerState) || invertColors
          ? textColor
          : blankLedColor)
      ..style = PaintingStyle.fill;

    for (int y = 0; y < verticalDots; y++) {
      final double offsetY = y * cellSize + dotRadius;
      for (int x = 0; x < horizontalDots; x++) {
        final double offsetX = x * cellSize + dotRadius;
        canvas.drawCircle(
          Offset(offsetX, offsetY),
          dotRadius,
          paint,
        );
      }
    }
  }

  /// Draws the text LEDs on the canvas
  void _drawTextLEDs(Canvas canvas, double dotRadius, double cellSize,
      double textWidth, double textHeight, double dx, double dy) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = (flickerMode && flickerState) || invertColors
          ? blankLedColor
          : textColor;

    for (int y = 0; y < verticalDots; y++) {
      final double boardY = y * cellSize;
      final double offsetY = boardY + dotRadius;
      for (int x = 0; x < horizontalDots; x++) {
        final double boardX = x * cellSize;
        final double offsetX = boardX + dotRadius;

        double textX = boardX - dx;
        double textY = boardY - dy;

        if (_isWithinTextBounds(textX, textY, textWidth, textHeight)) {
          int pixelX = mirrorMode
              ? (textImage.width - 1 - textX.floor())
              : textX.floor();
          int pixelY = textY.floor();

          int index = pixelY * textImage.width + pixelX;

          final pixel = _getPixelColor(pixels, index);

          if (pixel.alpha > 0) {
            canvas.drawCircle(
              Offset(offsetX, offsetY),
              dotRadius,
              paint,
            );
          }
        }
      }
    }
  }

  /// Checks if the coordinates are within the bounds of the text image
  bool _isWithinTextBounds(
      double textX, double textY, double textWidth, double textHeight) {
    return textX >= 0 && textX < textWidth && textY >= 0 && textY < textHeight;
  }

  /// Helper function to get the color of a pixel from pixel data
  Color _getPixelColor(Uint32List pixels, int index) {
    if (index >= 0 && index < pixels.length) {
      int pixelValue = pixels[index];
      int a = (pixelValue >> 24) & 0xFF;
      int r = (pixelValue >> 16) & 0xFF;
      int g = (pixelValue >> 8) & 0xFF;
      int b = pixelValue & 0xFF;
      return Color.fromARGB(a, r, g, b);
    }
    return Colors.transparent;
  }

  @override
  bool shouldRepaint(covariant DotMatrixPainter oldDelegate) {
    return oldDelegate.textImage != textImage ||
        oldDelegate.flickerState != flickerState;
  }
}
