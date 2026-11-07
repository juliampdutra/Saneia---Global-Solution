import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SaneiaApp());
}

class SaneiaApp extends StatelessWidget {
  const SaneiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Saneia',
      theme: AppTheme.light,
      home: const SplashScreen(),
    );
  }
}
