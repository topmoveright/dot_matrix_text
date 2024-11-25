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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  String text = 'Hello World';
  TextEditingController textController = TextEditingController();
  double ledSize = 4.0;
  double ledSpacing = 2.0;
  Color blankLedColor = blankLedColors.first;
  TextStyle textStyle = TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.bold,
    color: ledColors.first,
  );
  bool mirrorMode = false;
  bool flickerMode = false;
  Duration flickerSpeed = const Duration(seconds: 1);
  bool invertColors = false;
  Alignment alignment = Alignment.center;
  double boardWidth = 500.0;
  double boardHeight = 100.0;

  @override
  void initState() {
    textController.text = text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dot Matrix Text Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isSmallScreen
            ? _buildVerticalLayout(screenWidth, screenHeight)
            : _buildHorizontalLayout(screenWidth, screenHeight),
      ),
    );
  }

  Widget _buildVerticalLayout(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPreviewSection(),
          const SizedBox(height: 16),
          _buildControlsCard(),
        ],
      ),
    );
  }

  Widget _buildHorizontalLayout(double screenWidth, double screenHeight) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildPreviewSection(),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: _buildControlsCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildPreviewSection() {
    return Card(
      elevation: 4,
      child: Container(
        width: boardWidth,
        height: boardHeight,
        color: Colors.black,
        child: DotMatrixText(
          text: text,
          ledSize: ledSize,
          ledSpacing: ledSpacing,
          blankLedColor: blankLedColor,
          textStyle: textStyle,
          mirrorMode: mirrorMode,
          flickerMode: flickerMode,
          flickerSpeed: flickerSpeed,
          invertColors: invertColors,
          alignment: alignment,
          boardSize: Size(boardWidth, boardHeight),
        ),
      ),
    );
  }

  Widget _buildControlsCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(
              'Text',
              [
                TextField(
                  controller: textController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Text',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => text = value),
                ),
              ],
            ),
            _buildSection(
              'LED Properties',
              [
                _buildSlider(
                  label: 'Font Size',
                  value: textStyle.fontSize ?? 100,
                  min: 50.0,
                  max: 200.0,
                  onChanged: (value) => setState(
                      () => textStyle = textStyle.copyWith(fontSize: value)),
                ),
                _buildSlider(
                  label: 'LED Size',
                  value: ledSize,
                  min: 1.0,
                  max: 10.0,
                  onChanged: (value) => setState(() => ledSize = value),
                ),
                _buildSlider(
                  label: 'Spacing',
                  value: ledSpacing,
                  min: 1.0,
                  max: 10.0,
                  onChanged: (value) => setState(() => ledSpacing = value),
                ),
                _buildColorPicker(
                  label: 'LED Color',
                  value: textStyle.color!,
                  colors: ledColors,
                  onChanged: (color) => setState(
                      () => textStyle = textStyle.copyWith(color: color)),
                ),
                _buildColorPicker(
                  label: 'Blank LED',
                  value: blankLedColor,
                  colors: blankLedColors,
                  onChanged: (color) => setState(() => blankLedColor = color),
                ),
              ],
            ),
            _buildSection(
              'Effects',
              [
                _buildSwitch(
                  label: 'Mirror Mode',
                  value: mirrorMode,
                  onChanged: (value) => setState(() => mirrorMode = value),
                ),
                _buildSwitch(
                  label: 'Flicker Mode',
                  value: flickerMode,
                  onChanged: (value) => setState(() => flickerMode = value),
                ),
                if (flickerMode)
                  _buildSlider(
                    label: 'Flicker Speed',
                    value: flickerSpeed.inMilliseconds / 1000,
                    min: 0.1,
                    max: 3.0,
                    divisions: 29,
                    onChanged: (value) => setState(() => flickerSpeed =
                        Duration(milliseconds: (value * 1000).round())),
                  ),
                _buildSwitch(
                  label: 'Invert Colors',
                  value: invertColors,
                  onChanged: (value) => setState(() => invertColors = value),
                ),
              ],
            ),
            _buildSection(
              'Layout',
              [
                _buildDropdown<Alignment>(
                  label: 'Alignment',
                  value: alignment,
                  items: alignments,
                  itemBuilder: (alignment) =>
                      Text(alignment.toString().split('.').last),
                  onChanged: (value) {
                    if (value != null) setState(() => alignment = value);
                  },
                ),
                _buildSlider(
                  label: 'Width',
                  value: boardWidth,
                  min: 100.0,
                  max: 800.0,
                  onChanged: (value) => setState(() => boardWidth = value),
                ),
                _buildSlider(
                  label: 'Height',
                  value: boardHeight,
                  min: 50.0,
                  max: 400.0,
                  onChanged: (value) => setState(() => boardHeight = value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
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

  Widget _buildSlider({
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
          value: value,
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

  Widget _buildColorPicker({
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
            return InkWell(
              onTap: () => onChanged(color),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color,
                  border: Border.all(
                    color: color == value
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: color == value ? 2 : 1,
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
