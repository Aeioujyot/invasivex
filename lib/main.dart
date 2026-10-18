import 'package:flutter/material.dart';

import 'screens/root_shell.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const InvasiveXApp());
}

class InvasiveXApp extends StatelessWidget {
  const InvasiveXApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvasiveX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const RootShell(),
    );
  }
}
