import 'package:example/pages/submitted.dart';
import 'package:flutter/material.dart';
import 'package:unit_number_input/unit_number_input.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'unit_number_input Example',
      theme: ThemeData(),
      darkTheme: ThemeData.dark(), // standard dark theme
      themeMode: ThemeMode.system,
      home: const MyHomePage(title: 'unit_number_input'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<UnitNumberInputController> _controllers = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controllers = [
      UnitNumberInputController(initialSeconds: -1),
      UnitNumberInputController(initialSeconds: 20),
      UnitNumberInputController(),
      UnitNumberInputController(startInMinutesMode: true),
      UnitNumberInputController(initialSeconds: 500, startInMinutesMode: true),
      UnitNumberInputController(),
      UnitNumberInputController(initialSeconds: 45000),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text('Default', style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: UnitNumberInput(
                          controller: _controllers[0],
                          prefill: true,
                          valueRequired: false,
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text('External toggle', style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: UnitNumberInput(
                          controller: _controllers[1],
                          enableMinutesToggle: false,
                          onChanged: (seconds) {
                            print("Total seconds: $seconds");
                          },
                        ),
                      ),
                      Switch(
                        value: _controllers[1].minutesMode,
                        onChanged: (value) {
                          setState(() {
                            _controllers[1].toggleMode();
                          });
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        'No initial seconds or prefill',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: UnitNumberInput(
                          controller: _controllers[2],
                          prefill: false,
                          onChanged: (seconds) {
                            print("Total seconds: $seconds");
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        'No initial seconds, prefilled',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: UnitNumberInput(
                          controller: _controllers[3],
                          onChanged: (seconds) {
                            print("Total seconds: $seconds");
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        'Initial minutes, seconds',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: UnitNumberInput(
                          controller: _controllers[4],
                          onChanged: (seconds) {
                            print("Total seconds: $seconds");
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text(
                        'Field not required, not prefilled',
                        style: TextStyle(fontSize: 16),
                      ),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: UnitNumberInput(
                          controller: _controllers[5],
                          enableMinutesToggle: false,
                          valueRequired: false,
                          prefill: false,
                          onChanged: (seconds) {
                            print("Total seconds: $seconds");
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(width: 20),
                      Text('5 digits', style: TextStyle(fontSize: 16)),
                      const Spacer(),
                      FittedBox(
                        fit: BoxFit.contain,
                        child: UnitNumberInput(
                          controller: _controllers[6],
                          enableMinutesToggle: false,
                          maxSecondsDigits: 5,
                          onChanged: (seconds) {
                            print("Total seconds: $seconds");
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final values = _controllers
                            .map((c) => c.totalSeconds)
                            .toList();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubmittedPage(values: values),
                          ),
                        );
                      }
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
