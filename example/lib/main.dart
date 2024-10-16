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
      title: 'Dot Matrix Text Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  Colors.brown,
  Colors.lime,
  Colors.indigo,
];

const blankLedColors = [
  Color.fromRGBO(30, 30, 30, 1),
  Colors.transparent,
  Colors.black,
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
    // Get screen size for responsive sliders
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height / 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dot Matrix Text Example'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                invertColors: invertColors,
                alignment: alignment,
                boardSize: Size(boardWidth, boardHeight),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: textController,
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildSlider(
                    label: 'LED Size',
                    value: ledSize,
                    min: 1.0,
                    max: 10.0,
                    onChanged: (value) {
                      setState(() {
                        ledSize = value;
                      });
                    },
                  ),
                  _buildSlider(
                    label: 'LED Spacing',
                    value: ledSpacing,
                    min: 1.0,
                    max: 10.0,
                    onChanged: (value) {
                      setState(() {
                        ledSpacing = value;
                      });
                    },
                  ),
                  _buildSlider(
                    label: 'Font Size',
                    value: textStyle.fontSize ?? 100,
                    min: 50.0,
                    max: 200.0,
                    onChanged: (value) {
                      setState(() {
                        textStyle = textStyle.copyWith(fontSize: value);
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildDropdown<Color>(
                    label: 'LED Color',
                    value: textStyle.color!,
                    items: ledColors,
                    itemBuilder: (color) => Container(
                      width: 24,
                      height: 24,
                      color: color,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          textStyle = textStyle.copyWith(color: value);
                        });
                      }
                    },
                  ),
                  _buildDropdown<Color>(
                    label: 'Blank LED Color',
                    value: blankLedColor,
                    items: blankLedColors,
                    itemBuilder: (color) => Container(
                      width: 24,
                      height: 24,
                      color: color,
                    ),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          blankLedColor = value;
                        });
                      }
                    },
                  ),
                  _buildSwitch(
                    label: 'Mirror Mode',
                    value: mirrorMode,
                    onChanged: (value) {
                      setState(() {
                        mirrorMode = value;
                      });
                    },
                  ),
                  _buildSwitch(
                    label: 'Flicker Mode',
                    value: flickerMode,
                    onChanged: (value) {
                      setState(() {
                        flickerMode = value;
                      });
                    },
                  ),
                  _buildSwitch(
                    label: 'Invert Colors',
                    value: invertColors,
                    onChanged: (value) {
                      setState(() {
                        invertColors = value;
                      });
                    },
                  ),
                  _buildDropdown<Alignment>(
                    label: 'Alignment',
                    value: alignment,
                    items: alignments,
                    itemBuilder: (alignment) =>
                        Text(alignment.toString().split('.').last),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          alignment = value;
                        });
                      }
                    },
                  ),
                  _buildSlider(
                    label: 'Board Width',
                    value: boardWidth,
                    min: 100.0,
                    max: screenWidth,
                    onChanged: (value) {
                      setState(() {
                        boardWidth = value;
                      });
                    },
                  ),
                  _buildSlider(
                    label: 'Board Height',
                    value: boardHeight,
                    min: 100.0,
                    max: screenHeight,
                    onChanged: (value) {
                      setState(() {
                        boardHeight = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label)),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        SizedBox(
          width: 40,
          child: Text(value.toStringAsFixed(0)),
        ),
      ],
    );
  }

  Widget _buildSwitch({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(width: 100, child: Text(label)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
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
        SizedBox(width: 100, child: Text(label)),
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
}
