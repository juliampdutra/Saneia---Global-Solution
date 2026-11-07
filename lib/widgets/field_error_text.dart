import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Mensagem de erro exibida abaixo de campos que não são TextFormField
/// (como o seletor de categoria e o botão de bairro).
class FieldErrorText extends StatelessWidget {
  final String text;

  const FieldErrorText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 4),
      child: Text(
        text,
        style: const TextStyle(color: AppColors.error, fontSize: 12),
      ),
    );
  }
}
