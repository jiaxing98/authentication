import 'package:flutter/material.dart';

class BiometricDialog extends StatelessWidget {
  final void Function() onPositive;
  final void Function() onNegative;

  const BiometricDialog({
    super.key,
    required this.onPositive,
    required this.onNegative,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Enable Biometric Login"),
            Text(
              "Unlock your account with just a glance. Enjoy instant access. Would you like to enable this features?",
            ),
            FilledButton(
              onPressed: onPositive,
              child: Text("OKAY"),
            ),
            OutlinedButton(
              onPressed: onNegative,
              child: Text("CANCEL"),
            ),
          ],
        ),
      ),
    );
  }
}
