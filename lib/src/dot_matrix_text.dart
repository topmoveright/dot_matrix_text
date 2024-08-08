import 'dart:async';
import 'dart:typed_data';
import 'package:dot_matrix_text/src/dot_matrix_painter.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class DotMatrixText extends StatefulWidget {
  const DotMatrixText({
    super.key,
    required this.text,
    this.ledSize = 4.0,
    this.ledSpacing = 2.0,
    this.blankLedColor = const Color.fromRGBO(10, 10, 10, 1),
    this.boardSize,
    this.textStyle = const TextStyle(
      fontSize: 100.0,
      fontWeight: FontWeight.bold,
      color: Colors.red,
    ),
    this.mirrorMode = false,
    this.flickerMode = false,
    this.invertColors = false,
    this.alignment = Alignment.center,
  });

  /// The text to be displayed in dot matrix style.
  final String text;

  /// The size of each LED dot.
  final double ledSize;

  /// The spacing between each LED dot.
  final double ledSpacing;

  /// The color of the LEDs that are off (blank).
  final Color blankLedColor;

  /// The size of the board that will display the text. If null, the size is calculated based on text.
  final Size? boardSize;

  /// The text style for the displayed text.
  final TextStyle textStyle;

  /// Whether to mirror the text horizontally.
  final bool mirrorMode;

  /// Whether to enable a flickering effect on the LEDs.
  final bool flickerMode;

  /// Whether to invert the colors of the LEDs.
  final bool invertColors;

  /// The alignment of the text within the board.
  final Alignment alignment;

  @override
  DotMatrixTextState createState() => DotMatrixTextState();
}

class DotMatrixTextState extends State<DotMatrixText> {
  ui.Image? textImage;
  ByteData? imageByteData;
  bool flickerState = false;
  late TextPainter textPainter;
  late int verticalDots;
  late int horizontalDots;
  Timer? flickerTimer;

  @override
  void initState() {
    super.initState();
    _initializeTextPainter();
    _createTextImage();
    if (widget.flickerMode) {
      _startFlickerTimer();
    }
  }

  @override
  void didUpdateWidget(DotMatrixText oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updatePainterAndImage(oldWidget);
    _updateFlickerTimer(oldWidget);
  }

  /// Initializes the TextPainter and calculates the number of vertical and horizontal dots.
  void _initializeTextPainter() {
    textPainter = TextPainter(
      text: TextSpan(
          text: widget.text.isEmpty ? ' ' : widget.text,
          style: widget.textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textLayoutSize = widget.boardSize ?? textPainter.size;
    verticalDots = (textLayoutSize.height - widget.ledSpacing) ~/
        (widget.ledSize + widget.ledSpacing);
    horizontalDots = (textLayoutSize.width - widget.ledSpacing) ~/
        (widget.ledSize + widget.ledSpacing);
  }

  /// Creates an image from the text and converts it to ByteData.
  Future<void> _createTextImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final boardHeight =
        (widget.ledSize + widget.ledSpacing) * verticalDots - widget.ledSpacing;
    final yOffset = (boardHeight - textPainter.height) / 2;

    if (widget.mirrorMode) {
      canvas.scale(-1, 1);
      canvas.translate(-textPainter.width, 0);
    }

    textPainter.paint(canvas, Offset(0, yOffset));
    final picture = recorder.endRecording();
    final image = await picture.toImage(
      textPainter.width.ceil(),
      boardHeight.ceil(),
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.rawRgba);

    setState(() {
      textImage = image;
      imageByteData = byteData;
    });
  }

  /// Starts a timer to toggle the flicker state.
  void _startFlickerTimer() {
    flickerTimer?.cancel();
    flickerTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        flickerState = !flickerState;
      });
    });
  }

  /// Stops the flicker timer.
  void _stopFlickerTimer() {
    flickerTimer?.cancel();
    flickerTimer = null;
  }

  /// Updates the TextPainter and text image if relevant properties have changed.
  void _updatePainterAndImage(DotMatrixText oldWidget) {
    if (widget.text != oldWidget.text ||
        widget.textStyle != oldWidget.textStyle ||
        widget.ledSize != oldWidget.ledSize ||
        widget.ledSpacing != oldWidget.ledSpacing ||
        widget.mirrorMode != oldWidget.mirrorMode ||
        widget.boardSize != oldWidget.boardSize) {
      _initializeTextPainter();
      _createTextImage();
    }
  }

  /// Updates the flicker timer if the flicker mode has changed.
  void _updateFlickerTimer(DotMatrixText oldWidget) {
    if (widget.flickerMode != oldWidget.flickerMode) {
      if (widget.flickerMode) {
        _startFlickerTimer();
      } else {
        _stopFlickerTimer();
      }
    }
  }

  @override
  void dispose() {
    _stopFlickerTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: textImage != null && imageByteData != null
          ? DotMatrixPainter(
              textPainter: textPainter,
              textImage: textImage!,
              imageByteData: imageByteData!,
              ledSize: widget.ledSize,
              ledSpacing: widget.ledSpacing,
              textColor: widget.textStyle.color ?? Colors.red,
              blankLedColor: widget.blankLedColor,
              verticalDots: verticalDots,
              horizontalDots: horizontalDots,
              mirrorMode: widget.mirrorMode,
              flickerMode: widget.flickerMode,
              flickerState: flickerState,
              invertColors: widget.invertColors,
              alignment: widget.alignment,
            )
          : null,
      size: widget.boardSize ?? textPainter.size,
    );
  }
}
