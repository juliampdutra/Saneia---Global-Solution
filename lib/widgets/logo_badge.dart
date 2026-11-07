import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Logo do aplicativo dentro de um círculo branco.
/// O logo é azul com fundo transparente, então precisa do círculo para
/// aparecer sobre a AppBar e a Splash (que também são azuis).
class LogoBadge extends StatelessWidget {
  final double size;

  const LogoBadge({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.16),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.water_drop, color: AppColors.primary);
        },
      ),
    );
  }
}
