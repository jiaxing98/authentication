part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingEvent {}

final class OnboardingSignUpAccount extends OnboardingEvent {
  final String username;
  final String password;

  OnboardingSignUpAccount({
    required this.username,
    required this.password,
  });
}

final class OnboardingLoginAccount extends OnboardingEvent {
  final String username;
  final String password;

  OnboardingLoginAccount({
    required this.username,
    required this.password,
  });
}

final class OnboardingIsBiometricEnabled extends OnboardingEvent {}

final class OnboardingSetupBiometricLogin extends OnboardingEvent {
  final String username;
  final String password;

  OnboardingSetupBiometricLogin({
    required this.username,
    required this.password,
  });
}

final class OnboardingAuthenticateWithBiometric extends OnboardingEvent {}
