import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Linha com ícone + texto, reutilizada no card e na tela de detalhes.
class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.secondaryText),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.secondaryText),
          ),
        ),
      ],
    );
  }
}
