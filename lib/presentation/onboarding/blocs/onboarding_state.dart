part of 'onboarding_bloc.dart';

@immutable
sealed class OnboardingState extends Equatable {
  const OnboardingState();

  @override
  List<Object?> get props => [];
}

final class OnboardingInitial extends OnboardingState {
  final bool isBiometricEnabled;

  const OnboardingInitial({this.isBiometricEnabled = false});

  OnboardingInitial copyWith({
    bool? isBiometricEnabled,
  }) {
    return OnboardingInitial(
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
    );
  }

  @override
  List<Object?> get props => [isBiometricEnabled];
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
  final String username;

  const OnboardingLoginSuccess({required this.username});

  @override
  List<Object?> get props => [username];
}

final class OnboardingAskIfEnableBiometricAuth extends OnboardingState {
  const OnboardingAskIfEnableBiometricAuth();
}

final class OnboardingLoginFailure extends OnboardingState {
  const OnboardingLoginFailure();
}

final class OnboardingCredentialCorrupted extends OnboardingState {
  const OnboardingCredentialCorrupted();
}

final class OnboardingUnknownFailure extends OnboardingState {
  final String message;

  const OnboardingUnknownFailure({required this.message});
}
