import 'package:authentication/presentation/onboarding/blocs/onboarding_bloc.dart';
import 'package:authentication/presentation/onboarding/formz/inputs/password_input.dart';
import 'package:authentication/presentation/onboarding/formz/inputs/username_input.dart';
import 'package:authentication/presentation/onboarding/formz/states/onboarding_formz_state.dart';
import 'package:authentication/presentation/onboarding/widgets/onboarding_text.dart';
import 'package:authentication/router/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loader_overlay/loader_overlay.dart';

class LoginForm extends StatefulWidget {
  final void Function() onSwitchToSignUp;

  const LoginForm({super.key, required this.onSwitchToSignUp});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late OnboardingFormzState _formzState;
  late final TextEditingController _usernameCtrl;
  late final TextEditingController _passwordCtrl;

  bool isBiometricEnabled = false;
  bool hidePassword = true;

  @override
  void initState() {
    super.initState();

    _formzState = OnboardingFormzState();
    _usernameCtrl = TextEditingController();
    _passwordCtrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listener: _handleListener,
      child: Form(
        key: _formKey,
        child: Column(
          spacing: 16.0,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Login",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
            TextFormField(
              controller: _usernameCtrl,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.person),
                labelText: 'Username',
              ),
              onChanged: (text) =>
                  _formzState = _formzState.copyWith(username: UsernameInput.dirty(text)),
              validator: (value) => _formzState.username.validator(value ?? '')?.text(),
            ),
            TextFormField(
              controller: _passwordCtrl,
              obscureText: hidePassword,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                icon: Icon(Icons.lock),
                labelText: 'Password',
                errorMaxLines: 2,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  icon: hidePassword
                      ? Icon(Icons.visibility_off_outlined)
                      : Icon(Icons.visibility_outlined),
                ),
              ),
              onChanged: (text) =>
                  _formzState = _formzState.copyWith(password: PasswordInput.dirty(text)),
              validator: (value) => _formzState.password.validator(value ?? '')?.text(),
            ),
            BlocBuilder<OnboardingBloc, OnboardingState>(
              buildWhen: (prev, cur) =>
                  cur is OnboardingInitial || cur is OnboardingCredentialCorrupted,
              builder: (context, state) {
                return Row(
                  spacing: 16.0,
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          context.read<OnboardingBloc>().add(
                                OnboardingLoginAccount(
                                  username: _formzState.username.value,
                                  password: _formzState.password.value,
                                ),
                              );
                        },
                        child: Text("Login"),
                      ),
                    ),
                    if (state is OnboardingInitial && state.isBiometricEnabled)
                      IconButton.outlined(
                        onPressed: () {
                          context.read<OnboardingBloc>().add(OnboardingAuthenticateWithBiometric());
                        },
                        icon: Icon(Icons.fingerprint),
                      ),
                  ],
                );
              },
            ),
            OnboardingText(
              description: "Don't have an account yet?",
              label: 'Sign Up Here',
              onTap: () {
                widget.onSwitchToSignUp();
              },
            )
          ],
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, OnboardingState state) async {
    switch (state) {
      case OnboardingLoading():
        context.loaderOverlay.show();
      case OnboardingLoginSuccess():
        context.loaderOverlay.hide();
        context.pushReplacementNamed(
          Routes.home,
          queryParameters: {"username": state.username},
        );
      case OnboardingAskIfEnableBiometricAuth():
        context.loaderOverlay.hide();
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Biometric Login Access"),
            content: Text(
                "Do you want to enable biometrics for an easier, more secure way to access your account?"),
            actions: [
              FilledButton(
                onPressed: () {
                  context.read<OnboardingBloc>().add(
                        OnboardingSetupBiometricLogin(
                          username: _formzState.username.value,
                          password: _formzState.password.value,
                        ),
                      );
                  context.pop();
                },
                child: Text("OKAY"),
              ),
              OutlinedButton(
                onPressed: () {
                  context.pop();
                  context.pushReplacementNamed(
                    Routes.home,
                    queryParameters: {"username": _formzState.username.value},
                  );
                },
                child: Text("CANCEL"),
              )
            ],
          ),
        );
      case OnboardingLoginFailure():
        context.loaderOverlay.hide();
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Failed to Login"),
            content: Text("Wrong username or password. Or perhaps you have not sign up yet."),
            actions: [
              OutlinedButton(
                onPressed: () {
                  context.pop();
                },
                child: Text("OKAY"),
              )
            ],
          ),
        );
      case OnboardingCredentialCorrupted():
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Invalid Credential Found"),
            content: Text("Please re-enter your username and password to login."),
            actions: [
              OutlinedButton(
                onPressed: () {
                  context.pop();
                },
                child: Text("OKAY"),
              )
            ],
          ),
        );
      case OnboardingUnknownFailure():
        context.loaderOverlay.hide();
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Oops, Something Went Wrong!"),
            content: Text(state.message),
            actions: [
              OutlinedButton(
                onPressed: () {
                  context.pop();
                },
                child: Text("OKAY"),
              )
            ],
          ),
        );
        break;
      default:
        context.loaderOverlay.hide();
        break;
    }
  }
}
