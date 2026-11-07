import 'package:flutter/material.dart';

import '../models/priority_level.dart';
import '../models/report.dart';
import '../models/report_status.dart';
import '../theme/app_colors.dart';
import 'app_card.dart';
import 'info_row.dart';
import 'priority_chip.dart';
import 'status_chip.dart';

/// Item da lista de relatos da Home.
class ReportCard extends StatelessWidget {
  final Report report;
  final PriorityLevel priority;
  final VoidCallback onTap;
  final VoidCallback onConfirm;

  const ReportCard({
    super.key,
    required this.report,
    required this.priority,
    required this.onTap,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = report.status == ReportStatus.resolved;

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryLight,
            child: Icon(report.category.icon, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 4),
                InfoRow(
                  icon: Icons.place_outlined,
                  text: report.neighborhood,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    StatusChip(status: report.status),
                    if (!isResolved) PriorityChip(level: priority),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                tooltip: 'Também vejo isso',
                onPressed: onConfirm,
                icon: Icon(
                  report.confirmedByMe
                      ? Icons.visibility
                      : Icons.visibility_outlined,
                  color: report.confirmedByMe
                      ? AppColors.secondary
                      : AppColors.secondaryText,
                ),
              ),
              Text(
                '${report.confirmations}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
