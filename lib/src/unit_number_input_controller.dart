import 'package:flutter/material.dart';

class UnitNumberInputController extends ChangeNotifier {
  /// The total time in seconds.
  int _totalSeconds;

  /// Whether the input is in minutes mode.
  bool _minutesMode;

  UnitNumberInputController({
    int initialSeconds = 0,
    bool startInMinutesMode = false,
  }) : _totalSeconds = initialSeconds >= 0 ? initialSeconds : 0,
       _minutesMode = startInMinutesMode;

  int get totalSeconds => _totalSeconds;
  bool get minutesMode => _minutesMode;

  void setTotalSeconds(int seconds) {
    _totalSeconds = seconds;
    notifyListeners();
  }

  void toggleMode() {
    _minutesMode = !_minutesMode;
    notifyListeners();
  }
}
