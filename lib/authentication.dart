import 'package:local_auth/local_auth.dart';

abstract class Authentication {
  Future<bool> get canAuthenticateWithBiometrics;
  Future<bool> get isBiometricEnabled;

  Future<void> authenticate(String username, String password);
  Future<({String username, String password})> getCredential();

  Future<List<BiometricType>> getAvailableBiometrics();
  Future<bool> authenticateWithBiometric(String localizedReason);
  Future<void> enabledBiometricLogin(String password);
  Future<void> disabledBiometricLogin();
}
