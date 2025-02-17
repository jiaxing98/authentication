abstract class AuthenticationException implements Exception {}

class AuthenticationFailedException extends AuthenticationException {}

class UserAlreadyExistException extends AuthenticationException {}

class CredentialCorruptedException extends AuthenticationException {}
