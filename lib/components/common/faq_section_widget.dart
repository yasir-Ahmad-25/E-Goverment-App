// lib/components/common/faq_section_widget.dart
import 'package:e_govermenet/components/collapsible_widget.dart';
import 'package:flutter/material.dart';

class FaqSectionWidget extends StatelessWidget {
  final List<String> questions;
  final List<String> answers;

  const FaqSectionWidget({
    super.key,
    required this.questions,
    required this.answers,
  }) : assert(questions.length == answers.length, "Questions and Answers lists must have the same length.");

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "FAQ's",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const Divider(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: questions.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: CollapsibleWidget(
                title: questions[index],
                animationDuration: const Duration(milliseconds: 300),
                child: Text(answers[index]),
              ),
            );
          },
        ),
      ],
    );
  }
}