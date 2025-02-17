import 'package:authentication/presentation/onboarding/formz/inputs/password_input.dart';
import 'package:authentication/presentation/onboarding/formz/inputs/username_input.dart';
import 'package:formz/formz.dart';

class OnboardingFormzState with FormzMixin {
  final UsernameInput username;
  final PasswordInput password;

  OnboardingFormzState({
    UsernameInput? username,
    PasswordInput? password,
  })  : username = username ?? UsernameInput.pure(),
        password = password ?? PasswordInput.pure();

  OnboardingFormzState copyWith({
    UsernameInput? username,
    PasswordInput? password,
  }) {
    return OnboardingFormzState(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }

  @override
  List<FormzInput<dynamic, dynamic>> get inputs => [
        username,
        password,
      ];
}
