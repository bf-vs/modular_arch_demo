import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:modular_arch_demo/login/login_page.dart';
import 'package:modular_arch_demo/reset_pw/reset_pw_page.dart';
import 'package:modular_arch_demo/utils.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  runApp(const RootWidget());
}

class RootWidget extends StatelessWidget {
  const RootWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Localizations(
        locale: const Locale('en'),
        delegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.black),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: Overlay(
              initialEntries: [
                OverlayEntry(
                  maintainState: true,
                  opaque: true,
                  builder: (context) => const _RootView(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RootView extends StatefulWidget {
  const _RootView();

  @override
  State<_RootView> createState() => __RootViewState();
}

class __RootViewState extends State<_RootView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: AnimatedBuilder(
        animation: appState,
        builder: (context, _) {
          return Stack(
            children: appState.pages
                .map(
                  (page) => Positioned.fill(child: page),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

final appState = AppState();

class AppState extends ChangeNotifier {
  AppState() {
    openLogin();
  }

  LoginCubit? _loginCubit;
  ResetPasswordCubit? _resetPasswordCubit;

  void openLogin() {
    _loginCubit = LoginCubit(
      onExited: () {
        _loginCubit?.close();
        _loginCubit = null;
        notifyListeners();
      },
      onResetPasswordPressed: openResetPassword,
    );

    notifyListeners();
  }

  void openResetPassword({required String email}) {
    _resetPasswordCubit = ResetPasswordCubit(
      onExited: () {
        _resetPasswordCubit?.close();
        _resetPasswordCubit = null;
        notifyListeners();
      },
      prefillEmail: email,
    );
    notifyListeners();
  }

  List<Widget> get pages => [
        if (_loginCubit != null) ...[
          LoginPage(loginCubit: _loginCubit!),
        ],
        if (_resetPasswordCubit != null) ...[
          ResetPasswordPage(resetPasswordCubit: _resetPasswordCubit!),
        ],
      ];
}
