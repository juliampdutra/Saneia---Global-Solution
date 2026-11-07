import 'package:flutter/material.dart';

enum ReportCategory {
  sewage('Esgoto a céu aberto', Icons.warning_amber_rounded, 3),
  leak('Vazamento', Icons.water_drop, 2),
  noWater('Falta d\'água', Icons.format_color_reset, 2),
  drain('Bueiro entupido', Icons.grid_4x4, 1);

  const ReportCategory(this.label, this.icon, this.severity);

  final String label;
  final IconData icon;

  /// Peso usado no cálculo de prioridade (quanto maior, mais grave).
  final int severity;
}
