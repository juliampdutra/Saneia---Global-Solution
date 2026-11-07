import 'package:flutter/material.dart';

import '../models/priority_level.dart';
import '../theme/app_colors.dart';

class PriorityChip extends StatelessWidget {
  final PriorityLevel level;

  const PriorityChip({super.key, required this.level});

  Color get _color {
    switch (level) {
      case PriorityLevel.low:
        return AppColors.priorityLow;
      case PriorityLevel.medium:
        return AppColors.priorityMedium;
      case PriorityLevel.high:
        return AppColors.priorityHigh;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flag, size: 13, color: _color),
          const SizedBox(width: 4),
          Text(
            'Prioridade ${level.label}',
            style: TextStyle(
              color: _color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
