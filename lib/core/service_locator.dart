import 'package:authentication/core/database/database.dart';
import 'package:authentication/core/helpers/authentication/authentication.dart';
import 'package:authentication/core/helpers/authentication/authentication_impl.dart';
import 'package:authentication/data/repositories/authentication_repository_impl.dart';
import 'package:authentication/domain/repositories/authentication_repository.dart';
import 'package:authentication/env.dart';
import 'package:authentication/presentation/landing/blocs/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

Future<void> initializedApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();
  final sp = sl.registerSingleton<SharedPreferences>(sharedPreferences);

  final db = sl.registerSingleton<AppDatabase>(AppDatabase());
  final auth = sl.registerSingleton<Authentication>(AuthenticationImpl(sp: sp, key: Env.aesKey));
  final repo = sl.registerSingleton<AuthenticationRepository>(
      AuthenticationRepositoryImpl(db: db, auth: auth));

  sl.registerFactory<OnboardingBloc>(() => OnboardingBloc(repository: repo));
}
