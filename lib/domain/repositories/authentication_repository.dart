abstract class AuthenticationRepository {
  Future<void> signup(String username, String password);
  Future<void> login(String username, String password);
  Future<void> logout();
}
