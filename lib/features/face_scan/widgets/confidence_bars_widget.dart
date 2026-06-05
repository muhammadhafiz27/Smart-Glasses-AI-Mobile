import 'package:flutter/material.dart';

class ConfidenceBarsWidget extends StatelessWidget {
  final Map<String, double> scores;

  const ConfidenceBarsWidget({
    super.key,
    required this.scores,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: scores.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(e.key),
              LinearProgressIndicator(value: e.value),
            ],
          ),
        );
      }).toList(),
    );
  }
}