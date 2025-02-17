import 'package:authentication/core/database/database.dart';
import 'package:authentication/core/exceptions/authentication_exception.dart';
import 'package:authentication/domain/repositories/authentication_repository.dart';
import 'package:drift/drift.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository {
  final AppDatabase _db;

  AuthenticationRepositoryImpl({
    required AppDatabase db,
  }) : _db = db;

  @override
  Future<void> signup(String username, String password) async {
    final table = await (_db.select(_db.credential)..where((tbl) => tbl.username.equals(username)))
        .getSingleOrNull();
    if (table != null) throw UserAlreadyExistException();

    final insert = CredentialCompanion.insert(username: username, password: password);
    await _db.into(_db.credential).insertOnConflictUpdate(insert);
  }

  @override
  Future<void> login(String username, String password) async {
    final user = await (_db.select(_db.credential)..where((tbl) => tbl.username.equals(username)))
        .getSingleOrNull();
    if (user == null) throw AuthenticationFailedException();

    final valid = await (_db.select(_db.credential)
          ..where((tbl) => tbl.username.equals(username) & tbl.password.equals(password)))
        .getSingleOrNull();

    if (valid == null) throw AuthenticationFailedException();
  }

  @override
  Future<void> logout() async {}
}
