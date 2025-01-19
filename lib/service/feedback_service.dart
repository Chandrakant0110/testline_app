import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:audio_session/audio_session.dart';

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  final AudioPlayer _successPlayer = AudioPlayer();
  final AudioPlayer _errorPlayer = AudioPlayer();
  bool _isSoundEnabled = true;
  bool _isHapticEnabled = true;
  bool _isInitialized = false;

  // Initialize audio files
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configure audio session
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.assistanceSonification,
        ),
      ));

      // Load audio files
      await Future.wait([
        _successPlayer.setAsset('assets/sfx/sucess_effect.mp3'),
        _errorPlayer.setAsset('assets/sfx/error_sound.mp3'),
      ]);

      // Set volume and other properties
      await Future.wait([
        _successPlayer.setVolume(0.5),
        _errorPlayer.setVolume(0.5),
      ]);

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing audio: $e');
      // Reset state on error
      _isInitialized = false;
      await dispose();
    }
  }

  // Play success sound and vibration
  Future<void> playSuccess() async {
    if (!_isInitialized) {
      try {
        await initialize();
      } catch (e) {
        debugPrint('Failed to initialize on playSuccess: $e');
        return;
      }
    }

    if (_isHapticEnabled) {
      try {
        await HapticFeedback.mediumImpact();
      } catch (e) {
        debugPrint('Error playing haptic feedback: $e');
      }
    }

    if (_isSoundEnabled && _isInitialized) {
      try {
        await _successPlayer.seek(Duration.zero);
        await _successPlayer.play();
      } catch (e) {
        debugPrint('Error playing success sound: $e');
        // Try to reinitialize on error
        _isInitialized = false;
      }
    }
  }

  // Play error sound and vibration
  Future<void> playError() async {
    if (!_isInitialized) {
      try {
        await initialize();
      } catch (e) {
        debugPrint('Failed to initialize on playError: $e');
        return;
      }
    }

    if (_isHapticEnabled) {
      try {
        await HapticFeedback.heavyImpact();
      } catch (e) {
        debugPrint('Error playing haptic feedback: $e');
      }
    }

    if (_isSoundEnabled && _isInitialized) {
      try {
        await _errorPlayer.seek(Duration.zero);
        await _errorPlayer.play();
      } catch (e) {
        debugPrint('Error playing error sound: $e');
        // Try to reinitialize on error
        _isInitialized = false;
      }
    }
  }

  // Toggle sound effects
  void toggleSound() {
    _isSoundEnabled = !_isSoundEnabled;
  }

  // Toggle haptic feedback
  void toggleHaptic() {
    _isHapticEnabled = !_isHapticEnabled;
  }

  // Dispose resources
  Future<void> dispose() async {
    _isInitialized = false;
    try {
      await Future.wait([
        _successPlayer.dispose(),
        _errorPlayer.dispose(),
      ]);
    } catch (e) {
      debugPrint('Error disposing audio players: $e');
    }
  }

  // Getters for current state
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isHapticEnabled => _isHapticEnabled;
  bool get isInitialized => _isInitialized;
}
