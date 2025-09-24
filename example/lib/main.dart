import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dot_matrix_text/dot_matrix_text.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dot Matrix Text Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

const ledColors = [
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.orange,
  Colors.pink,
  Colors.teal,
  Colors.amber,
  Colors.indigo,
];

const blankLedColors = [
  Color.fromRGBO(30, 30, 30, 1),
  Colors.transparent,
  Colors.black12,
  Colors.black26,
  Colors.black38,
];

const alignments = [
  Alignment.topLeft,
  Alignment.topCenter,
  Alignment.topRight,
  Alignment.centerLeft,
  Alignment.center,
  Alignment.centerRight,
  Alignment.bottomLeft,
  Alignment.bottomCenter,
  Alignment.bottomRight,
];

class DotMatrixSettings {
  const DotMatrixSettings({
    required this.text,
    required this.ledSize,
    required this.ledSpacing,
    required this.blankLedColor,
    required this.textStyle,
    required this.mirrorMode,
    required this.flickerMode,
    required this.flickerSpeed,
    required this.invertColors,
    required this.alignment,
    required this.boardWidth,
    required this.boardHeight,
  });

  final String text;
  final double ledSize;
  final double ledSpacing;
  final Color blankLedColor;
  final TextStyle textStyle;
  final bool mirrorMode;
  final bool flickerMode;
  final Duration flickerSpeed;
  final bool invertColors;
  final Alignment alignment;
  final double boardWidth;
  final double boardHeight;

  Size get boardSize => Size(boardWidth, boardHeight);

  DotMatrixSettings copyWith({
    String? text,
    double? ledSize,
    double? ledSpacing,
    Color? blankLedColor,
    TextStyle? textStyle,
    bool? mirrorMode,
    bool? flickerMode,
    Duration? flickerSpeed,
    bool? invertColors,
    Alignment? alignment,
    double? boardWidth,
    double? boardHeight,
  }) {
    return DotMatrixSettings(
      text: text ?? this.text,
      ledSize: ledSize ?? this.ledSize,
      ledSpacing: ledSpacing ?? this.ledSpacing,
      blankLedColor: blankLedColor ?? this.blankLedColor,
      textStyle: textStyle ?? this.textStyle,
      mirrorMode: mirrorMode ?? this.mirrorMode,
      flickerMode: flickerMode ?? this.flickerMode,
      flickerSpeed: flickerSpeed ?? this.flickerSpeed,
      invertColors: invertColors ?? this.invertColors,
      alignment: alignment ?? this.alignment,
      boardWidth: boardWidth ?? this.boardWidth,
      boardHeight: boardHeight ?? this.boardHeight,
    );
  }

  static DotMatrixSettings initial() {
    return const DotMatrixSettings(
      text: 'Hello World',
      ledSize: 4.0,
      ledSpacing: 2.0,
      blankLedColor: Color.fromRGBO(30, 30, 30, 1),
      textStyle: TextStyle(
        fontSize: 80,
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      mirrorMode: false,
      flickerMode: false,
      flickerSpeed: Duration(seconds: 1),
      invertColors: false,
      alignment: Alignment.center,
      boardWidth: 500.0,
      boardHeight: 100.0,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late final TextEditingController _textController;
  late final ValueNotifier<DotMatrixSettings> _settingsNotifier;

  @override
  void initState() {
    super.initState();
    final initial = DotMatrixSettings.initial();
    _settingsNotifier = ValueNotifier<DotMatrixSettings>(initial);
    _textController = TextEditingController(text: initial.text);
  }

  @override
  void dispose() {
    _textController.dispose();
    _settingsNotifier.dispose();
    super.dispose();
  }

  void _updateSettings(
    DotMatrixSettings Function(DotMatrixSettings) transform,
  ) {
    _settingsNotifier.value = transform(_settingsNotifier.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dot Matrix Text Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          if (isSmallScreen) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DotMatrixPreview(settingsListenable: _settingsNotifier),
                  const SizedBox(height: 16),
                  DotMatrixControls(
                    settingsNotifier: _settingsNotifier,
                    textController: _textController,
                    onUpdate: _updateSettings,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: DotMatrixPreview(
                      settingsListenable: _settingsNotifier,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: DotMatrixControls(
                      settingsNotifier: _settingsNotifier,
                      textController: _textController,
                      onUpdate: _updateSettings,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DotMatrixPreview extends StatelessWidget {
  const DotMatrixPreview({
    super.key,
    required this.settingsListenable,
  });

  final ValueListenable<DotMatrixSettings> settingsListenable;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DotMatrixSettings>(
      valueListenable: settingsListenable,
      builder: (context, settings, _) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: settings.boardWidth,
                height: settings.boardHeight,
                child: DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.black),
                  child: DotMatrixText(
                    text: settings.text,
                    ledSize: settings.ledSize,
                    ledSpacing: settings.ledSpacing,
                    blankLedColor: settings.blankLedColor,
                    textStyle: settings.textStyle,
                    mirrorMode: settings.mirrorMode,
                    flickerMode: settings.flickerMode,
                    flickerSpeed: settings.flickerSpeed,
                    invertColors: settings.invertColors,
                    alignment: settings.alignment,
                    boardSize: settings.boardSize,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class DotMatrixControls extends StatelessWidget {
  const DotMatrixControls({
    super.key,
    required this.settingsNotifier,
    required this.textController,
    required this.onUpdate,
  });

  final ValueNotifier<DotMatrixSettings> settingsNotifier;
  final TextEditingController textController;
  final void Function(DotMatrixSettings Function(DotMatrixSettings)) onUpdate;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DotMatrixSettings>(
      valueListenable: settingsNotifier,
      builder: (context, settings, _) {
        if (textController.text != settings.text) {
          textController.value = textController.value.copyWith(
            text: settings.text,
            selection: TextSelection.collapsed(offset: settings.text.length),
            composing: TextRange.empty,
          );
        }

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSection(
                  context,
                  'Text',
                  [
                    TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Text',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) =>
                          onUpdate((prev) => prev.copyWith(text: value)),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'LED Properties',
                  [
                    _buildSlider(
                      context,
                      label: 'Font Size',
                      value: settings.textStyle.fontSize ?? 80,
                      min: 50.0,
                      max: 200.0,
                      onChanged: (value) => onUpdate(
                        (prev) => prev.copyWith(
                          textStyle:
                              prev.textStyle.copyWith(fontSize: value),
                        ),
                      ),
                    ),
                    _buildSlider(
                      context,
                      label: 'LED Size',
                      value: settings.ledSize,
                      min: 1.0,
                      max: 10.0,
                      onChanged: (value) =>
                          onUpdate((prev) => prev.copyWith(ledSize: value)),
                    ),
                    _buildSlider(
                      context,
                      label: 'Spacing',
                      value: settings.ledSpacing,
                      min: 1.0,
                      max: 10.0,
                      onChanged: (value) =>
                          onUpdate((prev) => prev.copyWith(ledSpacing: value)),
                    ),
                    _buildColorPicker(
                      context,
                      label: 'LED Color',
                      value: settings.textStyle.color ?? Colors.red,
                      colors: ledColors,
                      onChanged: (color) => onUpdate(
                        (prev) => prev.copyWith(
                          textStyle: prev.textStyle.copyWith(color: color),
                        ),
                      ),
                    ),
                    _buildColorPicker(
                      context,
                      label: 'Blank LED',
                      value: settings.blankLedColor,
                      colors: blankLedColors,
                      onChanged: (color) =>
                          onUpdate((prev) => prev.copyWith(blankLedColor: color)),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Effects',
                  [
                    _buildSwitch(
                      label: 'Mirror Mode',
                      value: settings.mirrorMode,
                      onChanged: (value) => onUpdate(
                          (prev) => prev.copyWith(mirrorMode: value)),
                    ),
                    _buildSwitch(
                      label: 'Flicker Mode',
                      value: settings.flickerMode,
                      onChanged: (value) => onUpdate((prev) {
                        return prev.copyWith(flickerMode: value);
                      }),
                    ),
                    if (settings.flickerMode)
                      _buildSlider(
                        context,
                        label: 'Flicker Speed',
                        value:
                            settings.flickerSpeed.inMilliseconds / 1000.0,
                        min: 0.1,
                        max: 3.0,
                        divisions: 29,
                        onChanged: (value) => onUpdate(
                          (prev) => prev.copyWith(
                            flickerSpeed: Duration(
                              milliseconds: (value * 1000).round(),
                            ),
                          ),
                        ),
                      ),
                    _buildSwitch(
                      label: 'Invert Colors',
                      value: settings.invertColors,
                      onChanged: (value) => onUpdate(
                          (prev) => prev.copyWith(invertColors: value)),
                    ),
                  ],
                ),
                _buildSection(
                  context,
                  'Layout',
                  [
                    _buildDropdown<Alignment>(
                      label: 'Alignment',
                      value: settings.alignment,
                      items: alignments,
                      itemBuilder: (alignment) =>
                          Text(alignment.toString().split('.').last),
                      onChanged: (value) {
                        if (value != null) {
                          onUpdate((prev) => prev.copyWith(alignment: value));
                        }
                      },
                    ),
                    _buildSlider(
                      context,
                      label: 'Width',
                      value: settings.boardWidth,
                      min: 100.0,
                      max: 800.0,
                      onChanged: (value) => onUpdate(
                          (prev) => prev.copyWith(boardWidth: value)),
                    ),
                    _buildSlider(
                      context,
                      label: 'Height',
                      value: settings.boardHeight,
                      min: 50.0,
                      max: 400.0,
                      onChanged: (value) => onUpdate(
                          (prev) => prev.copyWith(boardHeight: value)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<Widget> children,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(value.toStringAsFixed(1)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(label),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T value,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required ValueChanged<T?> onChanged,
  }) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        DropdownButton<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: itemBuilder(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildColorPicker(
    BuildContext context, {
    required String label,
    required Color value,
    required List<Color> colors,
    required ValueChanged<Color> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((color) {
            final isSelected = color == value;
            return InkWell(
              onTap: () => onChanged(color),
              borderRadius: BorderRadius.circular(4),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
