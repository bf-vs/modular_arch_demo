// ignore_for_file: strict_raw_type

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A simple lifecycle printer for demo purposes.
///
/// This mixin has no architectural value, please ignore it.
mixin LifecyclePrinter<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    debugPrint('Init $runtimeType');
  }

  @override
  void dispose() {
    debugPrint('Dispose $runtimeType');
    super.dispose();
  }
}

/// This observer has no architectural value, please ignore it.
class AppBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    printGreen('\n${bloc.runtimeType} received event:\n$event');
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    printGreen('\n${bloc.runtimeType} changed:\n'
        'From: ${change.currentState}\nTo: ${change.nextState}');
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    printGreen('\n${bloc.runtimeType}:\n$error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    printGreen('\n${bloc.runtimeType} closed');
    super.onClose(bloc);
  }

  void printGreen(String text) {
    for (final line in text.split('\n')) {
      developer.log('\x1B[32m$line\x1B[0m');
    }
  }
}

class TopSpacer extends StatelessWidget {
  const TopSpacer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).padding.top);
  }
}

class BottomSpacer extends StatelessWidget {
  const BottomSpacer({super.key, this.minSize = 16});

  final double minSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height:
          MediaQuery.of(context).padding.bottom.clamp(minSize, double.infinity),
    );
  }
}
