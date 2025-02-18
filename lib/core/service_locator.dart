import 'package:authentication/core/database/database.dart';
import 'package:authentication/core/helpers/biometric_authentication/biometric_authentication.dart';
import 'package:authentication/core/helpers/biometric_authentication/biometric_authentication_impl.dart';
import 'package:authentication/core/l10n/l10n.dart';
import 'package:authentication/core/theme/theme.dart';
import 'package:authentication/data/repositories/authentication_repository_impl.dart';
import 'package:authentication/domain/repositories/authentication_repository.dart';
import 'package:authentication/env.dart';
import 'package:authentication/presentation/onboarding/blocs/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;

Future<void> initializedApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  sl.registerSingleton<AppDatabase>(AppDatabase());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  final defaultTheme =
      appThemes[Env.defaultThemeData] ?? (light: RoseWoodX.light(), dark: RoseWoodX.dark());
  final theme = sl
      .registerSingleton<ThemeCubit>(ThemeCubit(sp: sharedPreferences, defaultTheme: defaultTheme));
  theme.loadTheme();

  sl.registerSingleton<L10nCubit>(
    L10nCubit(
      defaultLocale: Locale('en'),
      supportedLocales: [
        Locale('en'),
        Locale('zh'),
        Locale('ja'),
      ],
    ),
  );

  _injectHelpers();
  _injectRepositories();
  _injectBlocs();
}

void _injectHelpers() {
  sl.registerSingleton<BiometricAuthentication>(
    BiometricAuthenticationImpl(
      sp: sl.get<SharedPreferences>(),
      key: Env.aesKey,
      encodedIV: Env.encodedIV,
    ),
  );
}

void _injectRepositories() {
  sl.registerSingleton<AuthenticationRepository>(
    AuthenticationRepositoryImpl(db: sl.get<AppDatabase>()),
  );
}

void _injectBlocs() {
  // ! singleton - use BlocProvider.value to not close the stream

  // ! factory - use BlocProvider to create new instance
  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(
      bioAuth: sl.get<BiometricAuthentication>(),
      repository: sl.get<AuthenticationRepository>(),
    ),
  );
}
