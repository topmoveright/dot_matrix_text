import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DotMatrixPainter extends CustomPainter {
  final TextPainter textPainter;
  final ui.Image textImage;
  final ByteData imageByteData;
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
    required this.imageByteData,
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
  });

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
    for (int y = 0; y < verticalDots; y++) {
      for (int x = 0; x < horizontalDots; x++) {
        final paint = Paint()
          ..color = ((flickerMode && flickerState) || invertColors
              ? textColor
              : blankLedColor)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(
          Offset(x * cellSize + dotRadius, y * cellSize + dotRadius),
          dotRadius,
          paint,
        );
      }
    }
  }

  /// Draws the text LEDs on the canvas
  void _drawTextLEDs(Canvas canvas, double dotRadius, double cellSize,
      double textWidth, double textHeight, double dx, double dy) {
    for (int y = 0; y < verticalDots; y++) {
      for (int x = 0; x < horizontalDots; x++) {
        final boardX = x * cellSize;
        final boardY = y * cellSize;

        final textX = boardX - dx;
        final textY = boardY - dy;

        if (_isWithinTextBounds(textX, textY, textWidth, textHeight)) {
          final pixelOffset = Offset(textX, textY);
          final pixel =
              _getPixelColor(imageByteData, pixelOffset, textImage.width);

          if (pixel.computeLuminance() > 0) {
            final paint = Paint()
              ..style = PaintingStyle.fill
              ..color = (flickerMode && flickerState) || invertColors
                  ? blankLedColor
                  : textColor;
            canvas.drawCircle(
              Offset(boardX + dotRadius, boardY + dotRadius),
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

  /// Helper function to get the color of a pixel from byte data
  Color _getPixelColor(ByteData byteData, Offset offset, int width) {
    final pixelOffset = (offset.dy.toInt() * width + offset.dx.toInt()) * 4;
    if (pixelOffset >= 0 && pixelOffset < byteData.lengthInBytes - 3) {
      final r = byteData.getUint8(pixelOffset);
      final g = byteData.getUint8(pixelOffset + 1);
      final b = byteData.getUint8(pixelOffset + 2);
      final a = byteData.getUint8(pixelOffset + 3);
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
