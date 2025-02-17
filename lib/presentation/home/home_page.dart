import 'package:authentication/core/extensions/build_context.dart';
import 'package:authentication/core/l10n/l10n.dart';
import 'package:authentication/core/service_locator.dart';
import 'package:authentication/core/theme/theme.dart';
import 'package:authentication/domain/repositories/authentication_repository.dart';
import 'package:authentication/presentation/home/widgets/action_button.dart';
import 'package:authentication/presentation/home/widgets/expandable_fab.dart';
import 'package:authentication/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.read<ThemeCubit>().changeTheme(),
          icon: Icon(Icons.brush),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(context.l10n.appBarTitle),
        actions: [
          BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () => context.read<ThemeCubit>().changeMode(
                      switch (state.mode) {
                        ThemeMode.light => ThemeMode.dark,
                        ThemeMode.dark => ThemeMode.light,
                        ThemeMode.system =>
                          context.brightness == Brightness.light ? ThemeMode.dark : ThemeMode.light,
                      },
                    ),
                icon: Icon(state.mode == ThemeMode.light ? Icons.light_mode : Icons.dark_mode),
              );
            },
          ),
          IconButton(
            onPressed: () async {
              final repository = sl.get<AuthenticationRepository>();
              await repository.logout();
              if (!context.mounted) return;

              context.pushReplacementNamed(Routes.onboarding);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Welcome,"),
                Text(
                  widget.username,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(context.l10n.counterMessage),
                      Text(
                        '$_counter',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      SizedBox(height: 24.0),
                      OutlinedButton(
                        onPressed: _incrementCounter,
                        child: Text(context.l10n.incrementButton),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: BlocBuilder<L10nCubit, L10nState>(
        builder: (context, state) {
          return ExpandableFab(
            distance: 110,
            children: state.supportedLocales
                .map(
                  (e) => ActionButton(
                    locale: e,
                    onPressed: context.read<L10nCubit>().changeLocale,
                  ),
                )
                .toList(),
          );
        },
      ),
    );
  }
}
