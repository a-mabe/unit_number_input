import 'package:flutter/material.dart';

/// Page that displays submitted values
class SubmittedPage extends StatelessWidget {
  final List<int> values;
  const SubmittedPage({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submitted Values")),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: values.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final seconds = values[index];
          return ListTile(
            leading: Text("Field ${index + 1}"),
            title: Text("$seconds seconds"),
          );
        },
      ),
    );
  }
}
