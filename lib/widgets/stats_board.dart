import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'stat_card.dart';

/// Resumo com a quantidade de relatos em cada status.
class StatsBoard extends StatelessWidget {
  final int open;
  final int inReview;
  final int resolved;

  const StatsBoard({
    super.key,
    required this.open,
    required this.inReview,
    required this.resolved,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: 'Abertos',
            value: open,
            icon: Icons.error_outline,
            color: AppColors.open,
            backgroundColor: AppColors.openLight,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatCard(
            title: 'Em análise',
            value: inReview,
            icon: Icons.manage_search,
            color: AppColors.inReview,
            backgroundColor: AppColors.inReviewLight,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatCard(
            title: 'Resolvidos',
            value: resolved,
            icon: Icons.check_circle_outline,
            color: AppColors.resolved,
            backgroundColor: AppColors.resolvedLight,
          ),
        ),
      ],
    );
  }
}
