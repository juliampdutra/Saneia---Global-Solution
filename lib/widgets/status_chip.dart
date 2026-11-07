import 'package:flutter/material.dart';

import '../models/report_status.dart';
import '../theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  final ReportStatus status;

  const StatusChip({super.key, required this.status});

  Color get _color {
    switch (status) {
      case ReportStatus.open:
        return AppColors.open;
      case ReportStatus.inReview:
        return AppColors.inReview;
      case ReportStatus.resolved:
        return AppColors.resolved;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
