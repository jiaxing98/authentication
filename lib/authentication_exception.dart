abstract class AuthenticationException implements Exception {}

class AuthenticationFailedException extends AuthenticationException {}

class CredentialNotFoundException extends AuthenticationException {}
