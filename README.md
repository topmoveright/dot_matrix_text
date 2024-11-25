# Dot Matrix Text Plugin for Flutter

A Flutter plugin for creating customizable dot matrix text displays.

<img src="https://github.com/user-attachments/assets/28ff0bc6-d7ed-4720-8b7a-bd8bfb1d23e8">

## Features

- Customizable LED size and spacing
- Adjustable text style and color
- **Mirror mode** for reversed text display
- **Flicker mode** with adjustable speed
- **Invert colors** for different display styles
- Customizable board size and alignment
- High-performance rendering
- Modern Material 3 example app

## Getting Started

To use this plugin, add `dot_matrix_text` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  dot_matrix_text: ^0.2.0
```

### Parameters

| Parameter       | Type          | Default                                                                                                  | Description                                                                             |
|----------------|---------------|----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| `text`         | `String`      | Required                                                                                                 | The text to be displayed in dot matrix style.                                           |
| `ledSize`      | `double`      | `4.0`                                                                                                    | The size of each LED dot.                                                               |
| `ledSpacing`   | `double`      | `2.0`                                                                                                    | The spacing between each LED dot.                                                       |
| `blankLedColor`| `Color`       | `Color.fromRGBO(10, 10, 10, 1)`                                                                         | The color of the LEDs that are off (blank).                                             |
| `boardSize`    | `Size?`       | `null`                                                                                                   | The size of the board displaying the text. If `null`, size is calculated based on text. |
| `textStyle`    | `TextStyle`   | `TextStyle(fontSize: 100.0, fontWeight: FontWeight.bold, color: Colors.red)`                            | The text style for the displayed text.                                                  |
| `mirrorMode`   | `bool`        | `false`                                                                                                  | Whether to mirror the text horizontally.                                                |
| `flickerMode`  | `bool`        | `false`                                                                                                  | Whether to enable a flickering effect on the LEDs.                                      |
| `flickerSpeed` | `Duration`    | `Duration(seconds: 1)`                                                                                   | The speed of the LED flicker effect when flickerMode is enabled.                        |
| `invertColors` | `bool`        | `false`                                                                                                  | Whether to invert the colors of the LEDs.                                               |
| `alignment`    | `Alignment`   | `Alignment.center`                                                                                       | The alignment of the text within the board.                                             |

### Usage

Import the package in your Dart code:

```dart
import 'package:dot_matrix_text/dot_matrix_text.dart';
```

Basic usage:

```dart
DotMatrixText(text: 'Hello World');
```

### Customizing Appearance

You can customize various aspects of the dot matrix display:

```dart
DotMatrixText(
  text: 'Custom Text',
  ledSize: 5.0,
  ledSpacing: 3.0,
  blankLedColor: Colors.grey[800],
  textStyle: TextStyle(
    fontSize: 80,
    fontWeight: FontWeight.w600,
    color: Colors.green,
  ),
  mirrorMode: true,
  flickerMode: true,
  flickerSpeed: Duration(milliseconds: 500),
  invertColors: false,
);
```

### Setting a Custom Board Size

By default, the board size is calculated based on the text. You can set a custom size:

```dart
DotMatrixText(
  text: 'Fixed Size',
  boardSize: Size(300, 150),
  // ... other properties
);
```

## Additional Information

This plugin is optimized for performance, utilizing efficient rendering techniques to display dot matrix text with minimal overhead. It is built using Flutter Hooks for efficient state management.

### Features Highlight

- **Enhanced Performance**: Optimized rendering with cached paint objects and efficient pixel data handling
- **Customizable Flicker**: Adjustable flicker speed for more dynamic LED effects
- **Improved Alignment**: Better text positioning with responsive alignment controls
- **Modern Example App**: Material 3 design with comprehensive customization options

For more detailed examples and advanced usage, please refer to the example app in the GitHub repository.

## Issues and Feedback

Please file issues, bugs, or feature requests in our [issue tracker][tracker].

## Contributing

Contributions are welcome! If you would like to improve this plugin, please create a pull request with your changes.

## License

This project is licensed under the [MIT License][license] - see the LICENSE file for details.

## Hero LED Display App

The [`dot_matrix_text`][pub.dev] plugin was used to create the [Hero LED Display][heroleddisplay] app on the App Store. This app provides a customizable dot matrix display, allowing users to create unique LED sign simulations and retro-style text displays.

[tracker]: https://github.com/topmoveright/dot_matrix_text/issues
[license]: https://pub.dev/packages/dot_matrix_text/license
[pub.dev]: https://pub.dev/packages/dot_matrix_text
[heroleddisplay]: https://apps.apple.com/us/app/hero-led-display/id6557080198