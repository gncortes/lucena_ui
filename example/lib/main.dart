import 'package:flutter/material.dart';
import 'package:lucena_ui/lucena_ui.dart';

void main() => runApp(const ExemploApp());

class ExemploApp extends StatelessWidget {
  const ExemploApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.of(Brightness.light),
      home: const Scaffold(body: Center(child: Text('lucena_ui'))),
    );
  }
}
