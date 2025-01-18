import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class ProctorService with WindowListener {
  static final ProctorService _instance = ProctorService._internal();
  factory ProctorService() => _instance;
  ProctorService._internal();

  bool _isInitialized = false;
  int _tabSwitchCount = 0;
  DateTime? _lastPausedTime;
  Timer? _screenMonitoringTimer;
  bool _isTestTerminated = false;
  bool _isDesktop = false;

  VoidCallback? onTestTerminated;
  Function(String)? onWarning;

  Future<void> initialize({
    required VoidCallback onTestTerminated,
    required Function(String) onWarning,
  }) async {
    if (_isInitialized) return;

    this.onTestTerminated = onTestTerminated;
    this.onWarning = onWarning;

    try {
      _isDesktop = !kIsWeb &&
          (Platform.isWindows || Platform.isLinux || Platform.isMacOS);

      // Set preferred orientations for mobile
      if (!_isDesktop) {
        await SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);

        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.immersiveSticky,
          overlays: [],
        );
      }
      // Desktop-specific initialization
      else {
        await windowManager.ensureInitialized();
        windowManager.addListener(this);
        await windowManager.setFullScreen(true);
        await windowManager.focus();
      }

      _isInitialized = true;
      _startScreenMonitoring();
    } catch (e) {
      debugPrint('ProctorService initialization error: $e');
      rethrow;
    }
  }

  void _startScreenMonitoring() {
    _screenMonitoringTimer?.cancel();
    _screenMonitoringTimer =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isTestTerminated) {
        timer.cancel();
        return;
      }

      // Add additional monitoring logic here if needed
    });
  }

  @override
  void onWindowBlur() {
    if (_isDesktop) {
      _handleBackgroundSwitch('Window lost focus');
    }
  }

  @override
  void onWindowFocus() {
    if (_isDesktop && _lastPausedTime != null) {
      _checkReturnFromBackground();
    }
  }

  @override
  void onWindowClose() {
    if (_isDesktop) {
      _terminateTest('Window closed');
    }
  }

  void handleAppLifecycleState(AppLifecycleState state) {
    if (_isTestTerminated) return;

    switch (state) {
      case AppLifecycleState.paused:
        _handleBackgroundSwitch('App paused');
        break;
      case AppLifecycleState.resumed:
        if (_lastPausedTime != null) {
          _checkReturnFromBackground();
        }
        break;
      case AppLifecycleState.detached:
        _terminateTest('App detached');
        break;
      default:
        break;
    }
  }

  void _handleBackgroundSwitch(String reason) {
    _lastPausedTime = DateTime.now();
    _tabSwitchCount++;

    if (_tabSwitchCount >= 3) {
      _terminateTest('Too many tab switches detected ($reason)');
    } else {
      onWarning?.call(
          'Warning: Tab switching detected ($reason). ${3 - _tabSwitchCount} attempts remaining.');
    }
  }

  void _checkReturnFromBackground() {
    if (_lastPausedTime != null) {
      final pauseDuration = DateTime.now().difference(_lastPausedTime!);
      if (pauseDuration.inSeconds > 10) {
        _terminateTest(
            'App was in background for too long (${pauseDuration.inSeconds} seconds)');
      }
    }
  }

  void _terminateTest(String reason) {
    if (_isTestTerminated) return;

    _isTestTerminated = true;
    _screenMonitoringTimer?.cancel();
    onTestTerminated?.call();
    debugPrint('Test terminated: $reason');
  }

  Future<void> dispose() async {
    _screenMonitoringTimer?.cancel();

    try {
      if (_isDesktop) {
        windowManager.removeListener(this);
        await windowManager.setFullScreen(false);
      } else {
        await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        await SystemChrome.setPreferredOrientations([]);
      }
    } catch (e) {
      debugPrint('ProctorService disposal error: $e');
    }
  }

  bool get isTestTerminated => _isTestTerminated;

  // Helper method to reset the service state
  void reset() {
    _tabSwitchCount = 0;
    _lastPausedTime = null;
    _isTestTerminated = false;
    _startScreenMonitoring();
  }
}
