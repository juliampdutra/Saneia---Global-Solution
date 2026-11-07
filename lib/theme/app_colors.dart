import 'package:flutter/material.dart';

abstract final class AppColors {
  // Cores principais
  static const primary = Color(0xFF0B5C8C);
  static const primaryLight = Color(0xFFE3F1F9);
  static const secondary = Color(0xFF1BA39C);

  // Fundo e superfícies
  static const background = Color(0xFFF4F8FB);
  static const surface = Colors.white;
  static const border = Color(0xFFDCE6EE);

  // Texto
  static const text = Color(0xFF1C2B36);
  static const secondaryText = Color(0xFF5F7280);

  // Status do relato
  static const open = Color(0xFFE07A1F);
  static const openLight = Color(0xFFFDF1E6);
  static const inReview = Color(0xFF2B7BD3);
  static const inReviewLight = Color(0xFFE8F1FB);
  static const resolved = Color(0xFF2E9E5B);
  static const resolvedLight = Color(0xFFE8F6EE);

  // Prioridade
  static const priorityHigh = Color(0xFFC62828);
  static const priorityMedium = Color(0xFFE07A1F);
  static const priorityLow = Color(0xFF2E9E5B);

  // Erro
  static const error = Color(0xFFC62828);

  // Degradê usado na Splash
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, secondary],
  );
}
