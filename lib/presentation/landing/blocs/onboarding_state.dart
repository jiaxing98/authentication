part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingLoading extends OnboardingState {
  const OnboardingLoading();
}

final class OnboardingSignUpSuccess extends OnboardingState {
  const OnboardingSignUpSuccess();
}

final class OnboardingUserAlreadyExist extends OnboardingState {
  const OnboardingUserAlreadyExist();
}

final class OnboardingLoginSuccess extends OnboardingState {
  const OnboardingLoginSuccess();
}

final class OnboardingAskIfEnableBiometricAuth extends OnboardingState {
  const OnboardingAskIfEnableBiometricAuth();
}

final class OnboardingCredentialNotFound extends OnboardingState {
  const OnboardingCredentialNotFound();
}

final class OnboardingUnknownFailure extends OnboardingState {
  final String message;

  const OnboardingUnknownFailure({required this.message});
}
