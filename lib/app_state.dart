import 'package:flutter/widgets.dart';
import 'package:modular_arch_demo/login/login_page.dart';
import 'package:modular_arch_demo/reset_pw/reset_pw_page.dart';

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
