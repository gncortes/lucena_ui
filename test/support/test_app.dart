import 'package:flutter/material.dart';
import 'package:lucena_ui/lucena_ui.dart';

/// Envolve um widget com o tema do pacote, para os testes de widget.
class TestApp extends StatelessWidget {
  const TestApp({
    required this.child,
    this.themeMode = ThemeMode.light,
    super.key,
  });

  final Widget child;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.of(Brightness.light),
    darkTheme: AppTheme.of(Brightness.dark),
    themeMode: themeMode,
    home: child,
  );
}
