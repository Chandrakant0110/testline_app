# quixzy.ai

A modern, feature-rich quiz application built with Flutter that supports both mobile and desktop platforms.

## Features

### Quiz Taking Experience
- Dynamic quiz loading with real-time scoring
- Timed questions with configurable duration
- Progress tracking and score display
- Skip and navigation options for questions
- Beautiful animated UI with smooth transitions
- Support for markdown-formatted questions

### Quiz Configuration
- Configurable scoring system with positive and negative marking
- Question shuffling option
- Customizable quiz duration
- Support for different quiz types and difficulty levels
- Reading material integration
- Question feedback system

### Review System
- Detailed quiz review after completion
- Question-by-question review with correct answers
- Score summary and statistics
- Attempt history tracking
- Performance analytics

### Proctoring Features
- Built-in proctoring service
- App lifecycle state monitoring
- Test termination capabilities
- Anti-cheating measures

### Cross-Platform Support
- Responsive design for mobile devices
- Desktop support (Windows, Linux, macOS)
- Configurable window management for desktop platforms
- Minimum window size enforcement (800x600)

## Getting Started

### Prerequisites
- Flutter SDK
- Dart SDK
- For desktop development: Platform-specific requirements (Windows/Linux/macOS)

### Installation

1. Clone the repository:
```bash
git clone [repository-url]
```

2. Navigate to the project directory:
```bash
cd testline_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the application:
```bash
flutter run
```

## Project Structure

```
lib/
├── models/          # Data models for quiz, questions, etc.
├── screens/         # Main application screens
├── service/         # API and other services
├── theme/          # App theming
└── widgets/        # Reusable UI components
```

## Dependencies

- `flutter_markdown`: For rendering markdown content
- `window_manager`: For desktop window management
- `flutter_animate`: For UI animations
- `animated_text_kit`: For text animations

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
