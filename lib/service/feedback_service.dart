import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:audio_session/audio_session.dart';
import 'dart:async' show unawaited;

class FeedbackService {
  static final FeedbackService _instance = FeedbackService._internal();
  factory FeedbackService() => _instance;
  FeedbackService._internal();

  AudioPlayer? _successPlayer;
  AudioPlayer? _errorPlayer;
  bool _isSoundEnabled = true;
  bool _isHapticEnabled = true;
  bool _isInitialized = false;
  bool _isInitializing = false;

  // Initialize audio files
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    _isInitializing = true;

    try {
      // Create new instances of AudioPlayer
      _successPlayer = AudioPlayer();
      _errorPlayer = AudioPlayer();

      // Configure audio session
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.assistanceSonification,
        ),
      ));

      // Preload audio files
      await Future.wait([
        _successPlayer!.setAsset('assets/sfx/sucess_effect.mp3'),
        _errorPlayer!.setAsset('assets/sfx/error_sound.mp3'),
      ]);

      // Set volume and preload
      await Future.wait([
        _successPlayer!.setVolume(0.5),
        _errorPlayer!.setVolume(0.5),
        _successPlayer!.load(),
        _errorPlayer!.load(),
      ]);

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing audio: $e');
      _isInitialized = false;
      await dispose();
    } finally {
      _isInitializing = false;
    }
  }

  // Play haptic feedback based on feedback type
  Future<void> _playHapticFeedback(bool isSuccess) async {
    if (!_isHapticEnabled) return;

    try {
      if (isSuccess) {
        await HapticFeedback.lightImpact();
      } else {
        await HapticFeedback.heavyImpact();
      }
    } catch (e) {
      debugPrint('Error playing haptic feedback: $e');
    }
  }

  // Play success sound and vibration
  Future<void> playSuccess() async {
    if (!_isInitialized && !_isInitializing) {
      try {
        await initialize();
      } catch (e) {
        debugPrint('Failed to initialize on playSuccess: $e');
        return;
      }
    }

    unawaited(_playHapticFeedback(true));

    if (_isSoundEnabled && _isInitialized && _successPlayer != null) {
      try {
        await _successPlayer!.seek(Duration.zero);
        await _successPlayer!.play();
      } catch (e) {
        debugPrint('Error playing success sound: $e');
        _isInitialized = false;
      }
    }
  }

  // Play error sound and vibration
  Future<void> playError() async {
    if (!_isInitialized && !_isInitializing) {
      try {
        await initialize();
      } catch (e) {
        debugPrint('Failed to initialize on playError: $e');
        return;
      }
    }

    unawaited(_playHapticFeedback(false));

    if (_isSoundEnabled && _isInitialized && _errorPlayer != null) {
      try {
        await _errorPlayer!.seek(Duration.zero);
        await _errorPlayer!.play();
      } catch (e) {
        debugPrint('Error playing error sound: $e');
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
    _isInitializing = false;
    try {
      await Future.wait([
        _successPlayer?.dispose() ?? Future.value(),
        _errorPlayer?.dispose() ?? Future.value(),
      ]);
      _successPlayer = null;
      _errorPlayer = null;
    } catch (e) {
      debugPrint('Error disposing audio players: $e');
    }
  }

  // Getters for current state
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isHapticEnabled => _isHapticEnabled;
  bool get isInitialized => _isInitialized;
}
