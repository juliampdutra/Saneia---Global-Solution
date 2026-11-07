import 'package:flutter/material.dart';

import '../models/report_category.dart';
import '../theme/app_colors.dart';

/// Seletor de categoria reutilizado no filtro da Home e no formulário de relato.
class CategorySelector extends StatelessWidget {
  final ReportCategory? selected;
  final ValueChanged<ReportCategory?> onSelect;

  /// Exibe a opção "Todas" (usada no filtro).
  final bool showAll;

  /// Exibe os chips em uma única linha com rolagem horizontal.
  final bool horizontal;

  const CategorySelector({
    super.key,
    required this.selected,
    required this.onSelect,
    this.showAll = false,
    this.horizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[
      if (showAll)
        _buildChip(
          label: 'Todas',
          icon: Icons.apps,
          isSelected: selected == null,
          onTap: () => onSelect(null),
        ),
      for (final category in ReportCategory.values)
        _buildChip(
          label: category.label,
          icon: category.icon,
          isSelected: selected == category,
          onTap: () => onSelect(category),
        ),
    ];

    if (horizontal) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            for (final chip in chips)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: chip,
              ),
          ],
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips,
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 18,
        color: isSelected ? Colors.white : AppColors.primary,
      ),
      label: Text(label),
      selected: isSelected,
      showCheckmark: false,
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.text,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: isSelected ? AppColors.primary : AppColors.border,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onSelected: (_) => onTap(),
    );
  }
}
