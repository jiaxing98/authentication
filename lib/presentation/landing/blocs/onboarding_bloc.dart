import 'package:authentication/core/exceptions/authentication_exception.dart';
import 'package:authentication/domain/repositories/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final AuthenticationRepository _repository;

  OnboardingBloc({required AuthenticationRepository repository})
      : _repository = repository,
        super(OnboardingSignUpSuccess()) {
    on<OnboardingSignUpAccount>(_signUp);
    on<OnboardingLoginAccount>(_login);
    on<OnboardingSetupBiometricLogin>(_setupBiometricLogin);
  }

  Future<void> _signUp(OnboardingSignUpAccount event, Emitter<OnboardingState> emit) async {
    try {
      emit(OnboardingLoading());
      await _repository.signup(event.username, event.password);
      emit(OnboardingSignUpSuccess());
    } on UserAlreadyExistException catch (ex) {
      emit(OnboardingUserAlreadyExist());
    } catch (ex) {
      emit(OnboardingUnknownFailure(message: ex.toString()));
    }
  }

  Future<void> _login(OnboardingLoginAccount event, Emitter<OnboardingState> emit) async {
    try {
      emit(OnboardingLoading());
      await _repository.login(event.username, event.password);
      final canEnabled = await _repository.canBiometricLoginEnabled();
      canEnabled ? emit(OnboardingAskIfEnableBiometricAuth()) : emit(OnboardingLoginSuccess());
    } on CredentialNotFoundException catch (ex) {
      emit(OnboardingCredentialNotFound());
    } catch (ex) {
      emit(OnboardingUnknownFailure(message: ex.toString()));
    }
  }

  Future<void> _setupBiometricLogin(
      OnboardingSetupBiometricLogin event, Emitter<OnboardingState> emit) async {
    try {
      await _repository.enableBiometricLogin(event.password);
      emit(OnboardingLoginSuccess());
    } on CredentialNotFoundException catch (ex) {
      emit(OnboardingCredentialNotFound());
    } catch (ex) {
      emit(OnboardingUnknownFailure(message: ex.toString()));
    }
  }
}
