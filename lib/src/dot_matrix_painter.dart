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

  // Cached values for paint objects
  late final Paint _blankPaint;
  late final Paint _textPaint;
  late final double _dotRadius;
  late final double _cellSize;

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
  }) : pixels = imageByteData.buffer.asUint32List() {
    _dotRadius = ledSize / 2;
    _cellSize = ledSize + ledSpacing;
    _blankPaint = Paint()..style = PaintingStyle.fill;
    _textPaint = Paint()..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final textWidth = textImage.width.toDouble();
    final textHeight = textImage.height.toDouble();

    // Calculate the offset based on alignment once
    final dx = ((size.width - textPainter.width) / 2) * (1 + alignment.x);
    final dy = ((size.height - textPainter.height) / 2) * alignment.y;

    // Update paint colors based on current state
    _blankPaint.color = (flickerMode && flickerState) || invertColors
        ? textColor
        : blankLedColor;
    _textPaint.color = (flickerMode && flickerState) || invertColors
        ? blankLedColor
        : textColor;

    // Draw blank LEDs
    _drawBlankLEDs(canvas);

    // Draw text LEDs
    _drawTextLEDs(canvas, textWidth, textHeight, dx, dy);
  }

  /// Draws the blank LEDs on the canvas
  void _drawBlankLEDs(Canvas canvas) {
    for (int y = 0; y < verticalDots; y++) {
      final double offsetY = y * _cellSize + _dotRadius;
      for (int x = 0; x < horizontalDots; x++) {
        canvas.drawCircle(
          Offset(x * _cellSize + _dotRadius, offsetY),
          _dotRadius,
          _blankPaint,
        );
      }
    }
  }

  /// Draws the text LEDs on the canvas
  void _drawTextLEDs(Canvas canvas, double textWidth, double textHeight,
      double dx, double dy) {
    final int imageWidth = textImage.width;
    final Rect textBounds = Rect.fromLTWH(0, 0, textWidth, textHeight);

    for (int y = 0; y < verticalDots; y++) {
      final double boardY = y * _cellSize;
      final double offsetY = boardY + _dotRadius;
      final double textY = boardY - dy;

      if (textY < -_cellSize || textY >= textHeight + _cellSize) continue;

      for (int x = 0; x < horizontalDots; x++) {
        final double boardX = x * _cellSize;
        final double textX = boardX - dx;

        if (textX < -_cellSize || textX >= textWidth + _cellSize) continue;

        if (textBounds.contains(Offset(textX, textY))) {
          final int pixelX = textX.floor();
          final int pixelY = textY.floor();
          final int index = pixelY * imageWidth + pixelX;

          if (_hasPixelAlpha(index)) {
            canvas.drawCircle(
              Offset(boardX + _dotRadius, offsetY),
              _dotRadius,
              _textPaint,
            );
          }
        }
      }
    }
  }

  /// Efficient check for pixel alpha value
  bool _hasPixelAlpha(int index) {
    return index >= 0 &&
        index < pixels.length &&
        (pixels[index] >> 24) & 0xFF > 0;
  }

  @override
  bool shouldRepaint(covariant DotMatrixPainter oldDelegate) {
    return oldDelegate.textImage != textImage ||
        oldDelegate.flickerState != flickerState ||
        oldDelegate.textColor != textColor ||
        oldDelegate.blankLedColor != blankLedColor ||
        oldDelegate.invertColors != invertColors ||
        oldDelegate.alignment != alignment;
  }
}
