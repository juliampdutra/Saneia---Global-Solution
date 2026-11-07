import 'package:flutter/material.dart';

import '../models/report.dart';
import '../models/report_status.dart';
import '../repositories/report_repository.dart';
import '../theme/app_colors.dart';
import '../utils/formatters.dart';
import '../widgets/app_card.dart';
import '../widgets/info_row.dart';
import '../widgets/priority_chip.dart';
import '../widgets/section_title.dart';
import '../widgets/status_chip.dart';
import '../widgets/status_step.dart';

class ReportDetailScreen extends StatefulWidget {
  final Report report;

  const ReportDetailScreen({super.key, required this.report});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  final ReportRepository _repository = ReportRepository.instance;

  void _confirmReport() {
    setState(() {
      _repository.toggleConfirmation(widget.report);
    });
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final isResolved = report.status == ReportStatus.resolved;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhes do relato')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(
                        report.category.icon,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        report.category.label,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    StatusChip(status: report.status),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  report.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                ),
                const SizedBox(height: 12),
                InfoRow(icon: Icons.place_outlined, text: report.neighborhood),
                const SizedBox(height: 6),
                InfoRow(
                  icon: Icons.calendar_today_outlined,
                  text:
                      'Aberto em ${formatDate(report.createdAt)} (${report.daysOpen} dia(s))',
                ),
                if (!isResolved) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      PriorityChip(level: _repository.priorityLevel(report)),
                      const SizedBox(width: 8),
                      Text(
                        '${_repository.calculatePriority(report)} pontos',
                        style: const TextStyle(color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                Text(
                  report.description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.4,
                    color: AppColors.text,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionTitle('Andamento'),
                for (final status in ReportStatus.values)
                  StatusStep(
                    status: status,
                    done: status.index <= report.status.index,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Row(
              children: [
                const Icon(Icons.groups, color: AppColors.secondary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${report.confirmations} vizinho(s) confirmaram este problema',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _confirmReport,
            style: ElevatedButton.styleFrom(
              backgroundColor: report.confirmedByMe
                  ? AppColors.secondary
                  : AppColors.primary,
            ),
            icon: Icon(report.confirmedByMe ? Icons.check : Icons.visibility),
            label: Text(
              report.confirmedByMe
                  ? 'Você confirmou (desfazer)'
                  : 'Também vejo isso',
            ),
          ),
        ],
      ),
    );
  }
}
