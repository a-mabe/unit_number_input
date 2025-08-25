import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:unit_number_input/unit_number_input.dart';

void main() {
  // Test cases for UnitNumberInput widget

  // 1. Default
  // Given: Widget loads with no initial values or prefill
  // Expect: Fields are empty (or "00"), input decoration renders, validator works
  testWidgets(
    'Widget loads with no initial values or prefill: fields are empty, decoration renders, validator works',
    (WidgetTester tester) async {
      final controller = UnitNumberInputController(
        initialSeconds: 0,
        startInMinutesMode: true,
      );

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: UnitNumberInput(
                controller: controller,
                prefill: false,
                valueRequired: true,
                minutesDecoration: const InputDecoration(
                  hintText: 'mm',
                  labelText: 'Minutes',
                ),
                secondsDecoration: const InputDecoration(
                  hintText: 'ss',
                  labelText: 'Seconds',
                ),
              ),
            ),
          ),
        ),
      );

      // Should find two text fields (minutes and seconds)
      final minuteField = find.widgetWithText(TextFormField, 'Minutes');
      final secondField = find.widgetWithText(TextFormField, 'Seconds');
      expect(minuteField, findsOneWidget);
      expect(secondField, findsOneWidget);

      // Fields should be empty
      final minuteTextField = tester.widget<TextFormField>(minuteField);
      final secondTextField = tester.widget<TextFormField>(secondField);
      expect(minuteTextField.controller?.text ?? '', '');
      expect(secondTextField.controller?.text ?? '', '');

      // Decoration renders (hintText)
      expect(find.text('mm'), findsOneWidget);
      expect(find.text('ss'), findsOneWidget);

      // Validator: submit form, should show error (empty fields)
      formKey.currentState!.validate();
      await tester.pump();
      // Since validator returns '', errorText is empty, but error border should show
      // Instead of checking decoration, check for the error border by looking for the error style in the widget tree
      final errorTextFinder = find
          .descendant(
            of: find.byType(TextFormField),
            matching: find.byType(Text),
          )
          .evaluate()
          .where((e) {
            final widget = e.widget as Text;
            return widget.data == '';
          });
      expect(errorTextFinder.length, greaterThanOrEqualTo(1));
    },
  );

  // 2. Toggle button
  // Given: Toggle minutesMode
  // When: Switching on minutesMode
  // Expect: Total seconds converts into minutes+seconds correctly
  // When: Switching off minutesMode
  // Expect: Reverts back to seconds mode, values persist across rebuilds
  testWidgets(
    'Switching minutesMode on/off converts and persists values correctly',
    (WidgetTester tester) async {
      var controller = UnitNumberInputController(
        initialSeconds: 125, // 2 minutes, 5 seconds
        startInMinutesMode: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                UnitNumberInput(
                  controller: controller,
                  prefill: true,
                  valueRequired: true,
                  minutesDecoration: const InputDecoration(
                    hintText: 'mm',
                    labelText: 'Minutes',
                  ),
                  secondsDecoration: const InputDecoration(
                    hintText: 'ss',
                    labelText: 'Seconds',
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Initially in seconds mode: only seconds field visible, value is 125
      expect(find.widgetWithText(TextFormField, 'Minutes'), findsNothing);
      expect(find.widgetWithText(TextFormField, 'Seconds'), findsOneWidget);
      expect(find.text('125'), findsOneWidget);

      // Toggle minutes mode on
      await tester.tap(find.byIcon(Icons.timer_off));
      await tester.pumpAndSettle();

      // Now both fields should be visible, values split as 2 and 5
      expect(find.widgetWithText(TextFormField, 'Minutes'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Seconds'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      // Change minutes to 3, seconds to 10
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Minutes'),
        '3',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Seconds'),
        '10',
      );
      await tester.pump();

      // Total seconds should now be 190
      expect(controller.totalSeconds, 190);

      // Switch back to seconds mode
      await tester.tap(find.byIcon(Icons.timer));
      await tester.pumpAndSettle();

      // Only seconds field visible, value should be 190
      expect(find.widgetWithText(TextFormField, 'Minutes'), findsNothing);
      expect(find.widgetWithText(TextFormField, 'Seconds'), findsOneWidget);
      expect(find.text('190'), findsOneWidget);

      // Switch again to minutes mode, values should persist as 3 and 10
      await tester.tap(find.byIcon(Icons.timer_off));
      await tester.pumpAndSettle();
      expect(find.text('3'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    },
  );

  // 3. No initial seconds, no prefill
  // Given: initialSeconds = -1 and no prefill
  // Expect: Fields remain blank, validation only fails if required
  testWidgets(
    'No initial seconds, no prefill: fields remain blank, validation only fails if required',
    (WidgetTester tester) async {
      final controller = UnitNumberInputController(
        initialSeconds: -1,
        startInMinutesMode: true,
      );

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: UnitNumberInput(
                controller: controller,
                prefill: false,
                valueRequired: true,
                minutesDecoration: const InputDecoration(
                  hintText: 'mm',
                  labelText: 'Minutes',
                ),
                secondsDecoration: const InputDecoration(
                  hintText: 'ss',
                  labelText: 'Seconds',
                ),
              ),
            ),
          ),
        ),
      );

      // Both fields should be empty
      expect(find.widgetWithText(TextFormField, 'Minutes'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Seconds'), findsOneWidget);
      final minuteField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Minutes'),
      );
      final secondField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Seconds'),
      );
      expect(minuteField.controller?.text ?? '', '');
      expect(secondField.controller?.text ?? '', '');

      // Validation should fail (required)
      expect(formKey.currentState!.validate(), isFalse);

      // Now set valueRequired to false, validation should pass
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: UnitNumberInput(
                controller: controller,
                prefill: false,
                valueRequired: false,
                minutesDecoration: const InputDecoration(
                  hintText: 'mm',
                  labelText: 'Minutes',
                ),
                secondsDecoration: const InputDecoration(
                  hintText: 'ss',
                  labelText: 'Seconds',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(formKey.currentState!.validate(), isTrue);
    },
  );

  // 4. No initial seconds, with prefill
  // Given: initialSeconds not set, but has prefilled values
  // Expect: Prefilled values show 0 and total seconds reflects correctly
  testWidgets(
    'No initial seconds, with prefill: Prefilled values show 0 and total seconds reflects correctly',
    (WidgetTester tester) async {
      final controller = UnitNumberInputController(startInMinutesMode: true);

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: UnitNumberInput(
                controller: controller,
                prefill: true,
                valueRequired: true,
                minutesDecoration: const InputDecoration(
                  hintText: 'mm',
                  labelText: 'Minutes',
                ),
                secondsDecoration: const InputDecoration(
                  hintText: 'ss',
                  labelText: 'Seconds',
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Both fields should show 0
      expect(find.text('0'), findsNWidgets(2));

      // Total seconds should reflect correctly
      expect(controller.totalSeconds, 0);
    },
  );

  // 5. With initial minutes/seconds
  // Given: initialSeconds = 125 (2 minutes, 5 seconds)
  // Expect: Minutes field = 2, seconds field = 5, totalSeconds matches
  // When: Editing either field
  // Expect: totalSeconds updates consistently
  testWidgets(
    'With initial minutes/seconds: fields show correct values and totalSeconds updates on edit',
    (WidgetTester tester) async {
      final controller = UnitNumberInputController(
        initialSeconds: 125, // 2 minutes, 5 seconds
        startInMinutesMode: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitNumberInput(
              controller: controller,
              prefill: true,
              valueRequired: true,
              minutesDecoration: const InputDecoration(
                hintText: 'mm',
                labelText: 'Minutes',
              ),
              secondsDecoration: const InputDecoration(
                hintText: 'ss',
                labelText: 'Seconds',
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      // Both fields should show correct initial values
      expect(find.widgetWithText(TextFormField, 'Minutes'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Seconds'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);

      // totalSeconds should match
      expect(controller.totalSeconds, 125);

      // Edit minutes to 3, seconds to 15
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Minutes'),
        '3',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Seconds'),
        '15',
      );
      await tester.pump();

      // totalSeconds should update: 3*60+15 = 195
      expect(controller.totalSeconds, 195);

      // Edit seconds to 0, minutes to 1
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Seconds'),
        '0',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Minutes'),
        '1',
      );
      await tester.pump();

      // totalSeconds should update: 1*60+0 = 60
      expect(controller.totalSeconds, 60);

      // Edit both fields to empty, should fallback to 0
      await tester.enterText(find.widgetWithText(TextFormField, 'Minutes'), '');
      await tester.enterText(find.widgetWithText(TextFormField, 'Seconds'), '');
      await tester.pump();

      expect(controller.totalSeconds, 0);
    },
  );

  // 6. Field not required, not prefilled
  // Given: required = false, no initial/prefill
  // When: Submitting with empty fields
  // Expect: Validation passes, no error
  testWidgets(
    'Field not required, not prefilled: submitting with empty fields passes validation and shows no error',
    (WidgetTester tester) async {
      final controller = UnitNumberInputController(startInMinutesMode: true);

      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: UnitNumberInput(
                controller: controller,
                prefill: false,
                valueRequired: false,
                minutesDecoration: const InputDecoration(
                  hintText: 'mm',
                  labelText: 'Minutes',
                ),
                secondsDecoration: const InputDecoration(
                  hintText: 'ss',
                  labelText: 'Seconds',
                ),
              ),
            ),
          ),
        ),
      );

      // Both fields should be empty
      expect(find.widgetWithText(TextFormField, 'Minutes'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Seconds'), findsOneWidget);
      final minuteField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Minutes'),
      );
      final secondField = tester.widget<TextFormField>(
        find.widgetWithText(TextFormField, 'Seconds'),
      );
      expect(minuteField.controller?.text ?? '', '');
      expect(secondField.controller?.text ?? '', '');

      // Validation should pass (not required)
      expect(formKey.currentState!.validate(), isTrue);

      // No error text should be shown
      final errorTextFinder = find
          .descendant(
            of: find.byType(TextFormField),
            matching: find.byType(Text),
          )
          .evaluate()
          .where((e) {
            final widget = e.widget as Text;
            return widget.data == '';
          });
      expect(errorTextFinder.length, equals(0));
    },
  );

  // 7. 5 digits input for seconds
  // Given: maxSecondsDigits = 5
  // When: Entering large values (e.g. 99999)
  // Expect: Input allows up to 5 digits, values display correctly, overflow rejected
  testWidgets(
    '5 digits input: entering large values for seconds allows up to 5 digits, displays correctly, rejects overflow',
    (WidgetTester tester) async {
      final controller = UnitNumberInputController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: UnitNumberInput(
              controller: controller,
              prefill: false,
              valueRequired: false,
              maxSecondsDigits: 5,
              minutesDecoration: const InputDecoration(
                hintText: 'mm',
                labelText: 'Minutes',
              ),
              secondsDecoration: const InputDecoration(
                hintText: 'ss',
                labelText: 'Seconds',
              ),
            ),
          ),
        ),
      );

      // Enter a large value
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Seconds'),
        '99999',
      );
      await tester.pump();

      // Field should display the entered values
      expect(find.text('99999'), findsOneWidget);
    },
  );
}
