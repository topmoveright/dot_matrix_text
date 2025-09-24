import 'dart:async';
import 'dart:math' as math;
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
    this.flickerSpeed = const Duration(seconds: 1),
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

  /// The speed of the flicker effect. Default is 1 second.
  final Duration flickerSpeed;

  /// Whether to invert the colors of the LEDs.
  final bool invertColors;

  /// The alignment of the text within the board.
  final Alignment alignment;

  @override
  DotMatrixTextState createState() => DotMatrixTextState();
}

class DotMatrixTextState extends State<DotMatrixText> {
  ui.Image? textImage;
  Uint8List? alphaMask;
  bool flickerState = false;
  late TextPainter textPainter;
  late int verticalDots;
  late int horizontalDots;
  Timer? flickerTimer;
  Size? _cachedBoardSize;
  late Size _textLayoutSize;

  @override
  void initState() {
    super.initState();
    _initializeTextPainter();
    _createTextImage();
    flickerState = widget.flickerMode;
    if (widget.flickerMode) {
      _startFlickerTimer();
    }
  }

  @override
  void didUpdateWidget(DotMatrixText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_shouldUpdatePainterAndImage(oldWidget)) {
      _initializeTextPainter();
      _createTextImage();
    }
    _updateFlickerTimer(oldWidget);
  }

  bool _shouldUpdatePainterAndImage(DotMatrixText oldWidget) {
    return widget.text != oldWidget.text ||
        widget.textStyle != oldWidget.textStyle ||
        widget.ledSize != oldWidget.ledSize ||
        widget.ledSpacing != oldWidget.ledSpacing ||
        widget.mirrorMode != oldWidget.mirrorMode ||
        widget.boardSize != oldWidget.boardSize;
  }

  /// Initializes the TextPainter and calculates the number of vertical and horizontal dots.
  void _initializeTextPainter() {
    final text = widget.text.isEmpty ? ' ' : widget.text;
    textPainter = TextPainter(
      text: TextSpan(text: text, style: widget.textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final providedSize = widget.boardSize ?? textPainter.size;
    final rawCellSize = widget.ledSize + widget.ledSpacing;
    final cellSize = rawCellSize > 0
        ? rawCellSize
        : (widget.ledSize > 0 ? widget.ledSize : 1.0);

    final safeWidth = math.max(cellSize, providedSize.width);
    final safeHeight = math.max(cellSize, providedSize.height);

    _textLayoutSize = Size(safeWidth, safeHeight);
    _cachedBoardSize = _textLayoutSize;

    final verticalCount =
        ((_textLayoutSize.height + widget.ledSpacing) / cellSize).floor();
    final horizontalCount =
        ((_textLayoutSize.width + widget.ledSpacing) / cellSize).floor();

    verticalDots = math.max(1, verticalCount);
    horizontalDots = math.max(1, horizontalCount);
  }

  /// Creates an image from the text and converts it to ByteData.
  Future<void> _createTextImage() async {
    final boardHeight = _calculateBoardHeight();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Calculate the width based on mirror mode
    final imageWidth = math.max(1, textPainter.width.ceil());

    if (widget.mirrorMode) {
      canvas.translate(imageWidth.toDouble(), 0);
      canvas.scale(-1, 1);
    }

    textPainter.paint(
        canvas, Offset(0, (boardHeight - textPainter.height) / 2));

    final picture = recorder.endRecording();
    final newImage = await picture.toImage(
      imageWidth,
      boardHeight.ceil(),
    );
    final newByteData =
        await newImage.toByteData(format: ui.ImageByteFormat.rawRgba);

    Uint8List? mask;
    if (newByteData != null) {
      final pixels = newByteData.buffer.asUint32List();
      mask = Uint8List(pixels.length);
      for (var i = 0; i < pixels.length; i++) {
        mask[i] = ((pixels[i] >> 24) & 0xFF) > 0 ? 1 : 0;
      }
    }

    if (mounted) {
      setState(() {
        // Dispose of old image before assigning new one
        textImage?.dispose();
        textImage = newImage;
        alphaMask = mask;
      });
    } else {
      newImage.dispose();
    }
  }

  double _calculateBoardHeight() {
    return (widget.ledSize + widget.ledSpacing) * verticalDots -
        widget.ledSpacing;
  }

  /// Starts a timer to toggle the flicker state.
  void _startFlickerTimer() {
    flickerTimer?.cancel();
    flickerTimer = Timer.periodic(widget.flickerSpeed, (_) {
      if (mounted) {
        setState(() => flickerState = !flickerState);
      }
    });
  }

  /// Stops the flicker timer.
  void _stopFlickerTimer() {
    flickerTimer?.cancel();
    flickerTimer = null;
  }

  /// Updates the flicker timer if the flicker mode or speed has changed.
  void _updateFlickerTimer(DotMatrixText oldWidget) {
    if (widget.flickerMode != oldWidget.flickerMode ||
        (widget.flickerMode && widget.flickerSpeed != oldWidget.flickerSpeed)) {
      if (widget.flickerMode) {
        setState(() => flickerState = true);
        _startFlickerTimer();
      } else {
        _stopFlickerTimer();
        if (flickerState) {
          setState(() => flickerState = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _stopFlickerTimer();
    textPainter.dispose();
    textImage?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (textImage == null || alphaMask == null) {
      return SizedBox.fromSize(size: _cachedBoardSize);
    }

    return CustomPaint(
      painter: DotMatrixPainter(
        textPainter: textPainter,
        textImage: textImage!,
        alphaMask: alphaMask!,
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
      ),
      size: _cachedBoardSize!,
    );
  }
}
