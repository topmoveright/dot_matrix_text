# Changelog



## 0.2.0

- Added customizable flicker speed control with immediate state updates
- Enhanced painter performance with optimized shouldRepaint checks
- Improved alignment handling and state management
- Added proper cleanup for timer resources
- Optimized widget rebuilds for better performance
- Enhanced example app with modern Material 3 design
- Added comprehensive control options in the example app

## 0.1.0

- Improved performance by creating the Paint object outside of the loop.
- Eliminated unnecessary computations by using the alpha value instead of computeLuminance().
- Optimized memory usage and performance by enhancing the way pixel data is accessed.
- Increased the code's completeness by implementing the mirrorMode feature.
- Minimized calculations inside the loop to enhance overall performance.

## 0.0.1

- Initial release of `dot_matrix_text` package.
- Display text using dot matrix style with customizable LED size and spacing.
- Support for custom text styles, including font size, weight, and color.
- Add optional mirroring mode for horizontal text reflection.
- Implement flicker mode to simulate flickering LEDs.
- Introduce invert colors mode for LED color inversion.
- Provide customizable blank LED color.
- Ensure compatibility with various board sizes or default to auto-calculated sizes based on text dimensions.
