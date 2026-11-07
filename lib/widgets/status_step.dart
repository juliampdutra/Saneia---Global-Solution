import 'package:flutter/material.dart';

import '../models/report_status.dart';
import '../theme/app_colors.dart';

/// Uma etapa do andamento do relato (aberto, em análise, resolvido).
class StatusStep extends StatelessWidget {
  final ReportStatus status;
  final bool done;

  const StatusStep({super.key, required this.status, required this.done});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            done ? Icons.check_circle : Icons.radio_button_unchecked,
            color: done ? AppColors.resolved : Colors.black26,
          ),
          const SizedBox(width: 10),
          Text(
            status.label,
            style: TextStyle(
              fontWeight: done ? FontWeight.w600 : FontWeight.normal,
              color: done ? AppColors.text : AppColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }
}
