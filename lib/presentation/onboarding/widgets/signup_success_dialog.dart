import 'package:flutter/material.dart';

class SignupSuccessDialog extends StatelessWidget {
  const SignupSuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
        child: Column(
          spacing: 16.0,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Sign Up Successfully"),
            Text(
              "Unlock your account with just a glance. Enjoy instant access. Would you like to enable this features?",
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OKAY"),
            ),
          ],
        ),
      ),
    );
  }
}
