import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modular_arch_demo/utils.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({required this.loginCubit, super.key});
  final LoginCubit loginCubit;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with LifecyclePrinter {
  String _input = '';
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TopSpacer(),
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: widget.loginCubit.onExited,
          ),
          Expanded(
            child: BlocBuilder<LoginCubit, LoginState>(
              bloc: widget.loginCubit,
              builder: (context, state) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Spacer(),
                    const Text('Login Page'),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      onChanged: (value) => _input = value,
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () => widget.loginCubit.login(email: _input),
                      child: const Text('Login'),
                    ),
                    ...switch (state) {
                      LoadingLoginState() => [
                          const SizedBox(height: 10),
                          const CircularProgressIndicator(),
                        ],
                      ErrorLoginState() => [
                          const SizedBox(height: 10),
                          const Text(
                            'Login failed, please try again',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      _ => []
                    },
                    const SizedBox(height: 10),
                    const Spacer(),
                    TextButton(
                      onPressed: () => widget.loginCubit
                          .onResetPasswordPressed(email: _input),
                      child: const Text('Forgot your passsword? Reset it'),
                    ),
                    const BottomSpacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({
    required void Function({required String email}) onResetPasswordPressed,
    required VoidCallback onExited,
  })  : _onResetPasswordPressed = onResetPasswordPressed,
        _onExited = onExited,
        super(InitialLoginState());

  final VoidCallback _onExited;
  void onExited() => _onExited();
  final void Function({required String email}) _onResetPasswordPressed;
  void onResetPasswordPressed({required String email}) =>
      _onResetPasswordPressed(email: email);

  Future<void> login({required String email}) async {
    emit(LoadingLoginState());

    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (DateTime.now().second % 3 == 0) {
      emit(AuthorizedLoginState(accessToken: 'token12345'));
    } else {
      emit(ErrorLoginState());
    }
  }
}

sealed class LoginState {}

class InitialLoginState extends LoginState {}

class LoadingLoginState extends LoginState {}

class AuthorizedLoginState extends LoginState {
  AuthorizedLoginState({required this.accessToken});

  final String accessToken;
}

class ErrorLoginState extends LoginState {}
