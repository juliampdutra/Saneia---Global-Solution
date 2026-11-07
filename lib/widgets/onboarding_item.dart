import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Uma página da introdução: imagem ou ícone, título e descrição.
class OnboardingItem extends StatelessWidget {
  final String title;
  final String description;

  /// Caminho de uma imagem em assets (opcional).
  final String? imagePath;

  /// Ícone exibido quando não há imagem.
  final IconData? icon;

  const OnboardingItem({
    super.key,
    required this.title,
    required this.description,
    this.imagePath,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 190,
            height: 190,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 140,
              height: 140,
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: imagePath != null
                  ? Image.asset(imagePath!)
                  : Icon(icon, size: 70, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              height: 1.4,
              color: AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
