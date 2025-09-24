import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class DotMatrixPainter extends CustomPainter {
  final TextPainter textPainter;
  final ui.Image textImage;
  final Uint8List alphaMask;
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
  late final List<double> _columnOffsets;
  late final List<double> _rowOffsets;
  late final List<double> _columnCenters;
  late final List<double> _rowCenters;
  late final Path _blankBoardPath;

  DotMatrixPainter({
    required this.textPainter,
    required this.textImage,
    required this.alphaMask,
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
  }) {
    _dotRadius = ledSize / 2;
    _cellSize = ledSize + ledSpacing;
    _blankPaint = Paint()..style = PaintingStyle.fill;
    _textPaint = Paint()..style = PaintingStyle.fill;
    _columnOffsets =
        List<double>.generate(horizontalDots, (x) => x * _cellSize);
    _rowOffsets = List<double>.generate(verticalDots, (y) => y * _cellSize);
    _columnCenters = List<double>.generate(
        horizontalDots, (x) => _columnOffsets[x] + _dotRadius);
    _rowCenters =
        List<double>.generate(verticalDots, (y) => _rowOffsets[y] + _dotRadius);

    final path = Path();
    for (int y = 0; y < verticalDots; y++) {
      for (int x = 0; x < horizontalDots; x++) {
        path.addOval(Rect.fromCircle(
          center: Offset(_columnCenters[x], _rowCenters[y]),
          radius: _dotRadius,
        ));
      }
    }
    _blankBoardPath = path;
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
    canvas.drawPath(_blankBoardPath, _blankPaint);
  }

  /// Draws the text LEDs on the canvas
  void _drawTextLEDs(Canvas canvas, double textWidth, double textHeight,
      double dx, double dy) {
    final int imageWidth = textImage.width;

    for (int y = 0; y < verticalDots; y++) {
      final double boardY = _rowOffsets[y];
      final double textY = boardY - dy;

      if (textY < 0 || textY >= textHeight) continue;

      final int pixelY = textY.floor();
      if (pixelY < 0 || pixelY >= textImage.height) continue;

      final double centerY = _rowCenters[y];

      for (int x = 0; x < horizontalDots; x++) {
        final double boardX = _columnOffsets[x];
        final double textX = boardX - dx;

        if (textX < 0 || textX >= textWidth) continue;

        final int pixelX = textX.floor();
        if (pixelX < 0 || pixelX >= imageWidth) continue;

        final int index = pixelY * imageWidth + pixelX;

        if (_hasPixelAlpha(index)) {
          canvas.drawCircle(
            Offset(_columnCenters[x], centerY),
            _dotRadius,
            _textPaint,
          );
        }
      }
    }
  }

  /// Efficient check for pixel alpha value
  bool _hasPixelAlpha(int index) {
    return index >= 0 && index < alphaMask.length && alphaMask[index] == 1;
  }

  @override
  bool shouldRepaint(covariant DotMatrixPainter oldDelegate) {
    return oldDelegate.textImage != textImage ||
        oldDelegate.flickerState != flickerState ||
        oldDelegate.textColor != textColor ||
        oldDelegate.blankLedColor != blankLedColor ||
        oldDelegate.invertColors != invertColors ||
        oldDelegate.alphaMask != alphaMask ||
        oldDelegate.alignment != alignment;
  }
}
