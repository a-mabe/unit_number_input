import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unit_number_input/src/input_decoration.dart';
import 'package:unit_number_input/src/input_formatter.dart';
import 'package:unit_number_input/src/unit_number_input_controller.dart';

export 'src/unit_number_input_controller.dart';

class UnitNumberInput extends StatefulWidget {
  /// The controller for managing the widget.
  final UnitNumberInputController controller;

  /// Callback function called when the seconds changes.
  final ValueChanged<int>? onChanged;

  /// The maximum number of total seconds allowed.
  final int? maxTotalSeconds;

  /// Decoration for the minutes input field.
  final InputDecoration? minutesDecoration;

  /// Decoration for the seconds input field.
  final InputDecoration? secondsDecoration;

  /// Whether to enable the minutes toggle button.
  final bool enableMinutesToggle;

  /// The maximum number of digits allowed in the minutes input field.
  final int maxMinutesDigits;

  /// The maximum number of digits allowed in the seconds input field.
  final int maxSecondsDigits;

  /// Whether a value is required, disables validator if false.
  final bool valueRequired;

  /// Whether the input is prefilled with the controller value.
  final bool prefill;

  /// Callback function called when the form field is saved.
  final FormFieldSetter<int>? onSaved;

  /// Focus node for the minutes input field
  final FocusNode? minutesFocusNode;

  /// Focus node for the seconds input field
  final FocusNode? secondsFocusNode;

  const UnitNumberInput({
    super.key,
    required this.controller,
    this.onChanged,
    this.maxTotalSeconds = 9999999,
    this.minutesDecoration = numberInputDecoration,
    this.secondsDecoration = numberInputDecoration,
    this.enableMinutesToggle = true,
    this.maxMinutesDigits = 2,
    this.maxSecondsDigits = 3,
    this.valueRequired = true,
    this.prefill = true,
    this.onSaved,
    this.minutesFocusNode,
    this.secondsFocusNode,
  });

  @override
  State<UnitNumberInput> createState() => _UnitNumberInputState();
}

class _UnitNumberInputState extends State<UnitNumberInput> {
  final TextEditingController minutesController = TextEditingController();
  final TextEditingController secondsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleControllerChanged);
    _updateControllersFromSeconds();
  }

  @override
  void didUpdateWidget(UnitNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_handleControllerChanged);
      widget.controller.addListener(_handleControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleControllerChanged);
    minutesController.dispose();
    secondsController.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    setState(_updateControllersFromSeconds);
  }

  bool _firstBuild = true;

  void _updateControllersFromSeconds() {
    int? totalSeconds = widget.controller.totalSeconds;
    final minutesMode = widget.controller.minutesMode;

    final maxSecondsDigits = minutesMode ? 2 : widget.maxSecondsDigits;

    if (_firstBuild && !widget.prefill) {
      minutesController.clear();
      secondsController.clear();
      _firstBuild = false;
      return;
    }

    if (_firstBuild) {
      // Populate initial values on first build only
      if (minutesMode) {
        final mins = totalSeconds ~/ 60;
        final secs = totalSeconds % 60;
        minutesController.text = mins.toString();
        secondsController.text = secs.toString();
      } else {
        secondsController.text = totalSeconds.toString();
        minutesController.clear();
      }
      _firstBuild = false;
      return;
    }

    // After first build, do NOT overwrite if user cleared fields
    if (minutesMode) {
      final mins = totalSeconds ~/ 60;
      final secs = totalSeconds % 60;

      minutesController.text = mins.toString();
      secondsController.text = secs.toString();
    } else {
      if (secondsController.text.isNotEmpty) {
        String secondsText = totalSeconds.toString();
        if (secondsText.length > maxSecondsDigits) {
          secondsText = secondsText.substring(0, maxSecondsDigits);
        }
        secondsController.text = secondsText;
      }
      minutesController.clear();
    }
  }

  void _updateSecondsFromControllers() {
    int totalSeconds = 0;

    if (widget.controller.minutesMode) {
      final minsText = minutesController.text.trim();
      final secsText = secondsController.text.trim();

      final mins = minsText.isEmpty ? 0 : int.tryParse(minsText) ?? 0;
      final secs = secsText.isEmpty ? 0 : int.tryParse(secsText) ?? 0;

      totalSeconds = mins * 60 + secs;
    } else {
      final secsText = secondsController.text.trim();
      totalSeconds = secsText.isEmpty ? 0 : int.tryParse(secsText) ?? 0;
    }

    if (widget.maxTotalSeconds != null &&
        totalSeconds > widget.maxTotalSeconds!) {
      totalSeconds = widget.maxTotalSeconds!;
    }

    widget.controller.setTotalSeconds(totalSeconds);
    if (widget.onChanged != null) {
      widget.onChanged!(totalSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutesMode = widget.controller.minutesMode;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (minutesMode)
          _buildNumberField(
            controller: minutesController,
            maxDigits: widget.maxMinutesDigits,
            decoration: widget.minutesDecoration,
            onChanged: _updateSecondsFromControllers,
            focusNode: widget.minutesFocusNode,
            maxValue: 99,
          ),
        if (minutesMode)
          SizedBox(
            width: 20,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
              child: Text(
                'm',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        _buildNumberField(
          controller: secondsController,
          maxDigits: minutesMode ? 2 : widget.maxSecondsDigits,
          decoration: widget.secondsDecoration,
          onChanged: _updateSecondsFromControllers,
          focusNode: widget.secondsFocusNode,
          maxValue: minutesMode ? 59 : widget.maxTotalSeconds!.toDouble(),
        ),
        SizedBox(
          width: 20,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 6),
            child: Text(
              's',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        if (widget.enableMinutesToggle)
          IconButton(
            icon: Icon(minutesMode ? Icons.timer : Icons.timer_off),
            onPressed: () {
              widget.controller.toggleMode(); // controller drives everything
            },
          ),
      ],
    );
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required int maxDigits,
    required InputDecoration? decoration,
    required VoidCallback onChanged,
    required FocusNode? focusNode,
    required double maxValue,
  }) {
    return SizedBox(
      width: 20.0 * maxDigits,
      child: TextFormField(
        controller: controller,
        maxLength: maxDigits,
        style: const TextStyle(fontSize: 30),
        textAlign: TextAlign.end,
        keyboardType: TextInputType.number,
        focusNode: focusNode,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          NumericalRangeFormatter(min: 0, max: maxValue),
        ],
        onChanged: (_) => onChanged(),
        decoration: decoration,
        validator: (value) {
          if (!widget.valueRequired) return null;
          if (controller == secondsController &&
              widget.controller.minutesMode) {
            // In minutes mode, seconds can be empty or 0
            return null;
          }
          if (value == null ||
              value.isEmpty ||
              int.tryParse(value) == null ||
              int.parse(value) <= 0) {
            return '';
          }
          return null;
        },
        onSaved: widget.onSaved == null
            ? null
            : (value) {
                int? intValue = int.tryParse(value ?? '');
                widget.onSaved!(intValue ?? 0);
              },
      ),
    );
  }
}
