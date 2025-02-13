import 'package:formz/formz.dart';

enum UsernameValidationError { empty }

class UsernameInput extends FormzInput<String, UsernameValidationError> {
  const UsernameInput.pure([super.value = '']) : super.pure();

  const UsernameInput.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) {
      return UsernameValidationError.empty;
    }

    return null;
  }
}

extension PasswordValidationErrorExt on UsernameValidationError {
  String text() {
    switch (this) {
      case UsernameValidationError.empty:
        return 'Please enter a username';
    }
  }
}
