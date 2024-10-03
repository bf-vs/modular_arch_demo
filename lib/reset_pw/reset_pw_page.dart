import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modular_arch_demo/utils.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({required this.resetPasswordCubit, super.key});
  final ResetPasswordCubit resetPasswordCubit;
  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage>
    with LifecyclePrinter {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.resetPasswordCubit.prefillEmail;
  }

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
            onPressed: widget.resetPasswordCubit.onExited,
          ),
          Expanded(
            child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
              bloc: widget.resetPasswordCubit,
              builder: (context, state) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: switch (state) {
                    LoadingResetPasswordState() => [
                        const CircularProgressIndicator(),
                      ],
                    SuccessResetPasswordState() => [
                        const Text('Password reset email sent. ✔️'),
                      ],
                    _ => [
                        const Text('Reset Password Page'),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(hintText: 'E-mail'),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => widget.resetPasswordCubit
                              .resetPassword(email: _controller.text),
                          child: const Text('Reset Password'),
                        ),
                        ...switch (state) {
                          ErrorResetPasswordState() => [
                              const SizedBox(height: 10),
                              const Text(
                                'Reset password failed, please try again',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          _ => []
                        },
                      ],
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit({
    required this.prefillEmail,
    required VoidCallback onExited,
  })  : _onExited = onExited,
        super(InitialResetPasswordState());
  final String prefillEmail;
  final VoidCallback _onExited;
  void onExited() => _onExited();

  Future<void> resetPassword({required String email}) async {
    emit(LoadingResetPasswordState());

    await Future<void>.delayed(const Duration(milliseconds: 200));

    if (DateTime.now().second % 3 == 0) {
      emit(SuccessResetPasswordState());
    } else {
      emit(ErrorResetPasswordState());
    }
  }
}

sealed class ResetPasswordState {}

class InitialResetPasswordState extends ResetPasswordState {}

class LoadingResetPasswordState extends ResetPasswordState {}

class SuccessResetPasswordState extends ResetPasswordState {}

class ErrorResetPasswordState extends ResetPasswordState {}
