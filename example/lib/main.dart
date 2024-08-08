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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dot Matrix Text Example'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
              child: Center(
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
                Row(
                  children: [
                    const Text('LED Size'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Slider(
                        value: ledSize,
                        min: 1.0,
                        max: 10.0,
                        onChanged: (value) {
                          setState(() {
                            ledSize = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('LED Spacing'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Slider(
                        value: ledSpacing,
                        min: 1.0,
                        max: 10.0,
                        onChanged: (value) {
                          setState(() {
                            ledSpacing = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Font Size'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Slider(
                        value: textStyle.fontSize ?? 100,
                        min: 50.0,
                        max: 200.0,
                        onChanged: (value) {
                          setState(() {
                            textStyle = textStyle.copyWith(fontSize: value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('LED Color'),
                    const SizedBox(width: 20),
                    DropdownButton<Color>(
                      value: textStyle.color!,
                      items: ledColors.map((color) {
                        return DropdownMenuItem<Color>(
                          value: color,
                          child: Container(
                            width: 24,
                            height: 24,
                            color: color,
                          ),
                        );
                      }).toList(),
                      onChanged: (Color? value) {
                        if (value != null) {
                          setState(() {
                            textStyle = textStyle.copyWith(color: value);
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Blank LED Color'),
                    const SizedBox(width: 20),
                    DropdownButton<Color>(
                      value: blankLedColor,
                      items: blankLedColors.map((color) {
                        return DropdownMenuItem<Color>(
                          value: color,
                          child: Container(
                            width: 24,
                            height: 24,
                            color: color,
                          ),
                        );
                      }).toList(),
                      onChanged: (Color? value) {
                        if (value != null) {
                          setState(() {
                            blankLedColor = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Mirror Mode'),
                    const SizedBox(width: 20),
                    Switch(
                      value: mirrorMode,
                      onChanged: (value) {
                        setState(() {
                          mirrorMode = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Flicker Mode'),
                    const SizedBox(width: 20),
                    Switch(
                      value: flickerMode,
                      onChanged: (value) {
                        setState(() {
                          flickerMode = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Invert Colors'),
                    const SizedBox(width: 20),
                    Switch(
                      value: invertColors,
                      onChanged: (value) {
                        setState(() {
                          invertColors = value;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Alignment'),
                    const SizedBox(width: 20),
                    DropdownButton<Alignment>(
                      value: alignment,
                      items: alignments.map((alignment) {
                        return DropdownMenuItem<Alignment>(
                          value: alignment,
                          child: Text(alignment.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (Alignment? value) {
                        if (value != null) {
                          setState(() {
                            alignment = value;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text('Board Width'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Slider(
                        value: boardWidth,
                        min: 100.0,
                        max: 500.0,
                        onChanged: (value) {
                          setState(() {
                            boardWidth = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Board Height'),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Slider(
                        value: boardHeight,
                        min: 100.0,
                        max: 500.0,
                        onChanged: (value) {
                          setState(() {
                            boardHeight = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
