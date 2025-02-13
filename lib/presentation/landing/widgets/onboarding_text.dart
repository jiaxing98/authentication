import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class OnboardingText extends StatelessWidget {
  final String description;
  final String label;
  final void Function() onTap;

  const OnboardingText({
    super.key,
    required this.description,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "$description ",
        children: [
          TextSpan(
            text: label,
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
    );
  }
}
