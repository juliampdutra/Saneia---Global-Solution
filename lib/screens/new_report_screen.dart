import 'package:flutter/material.dart';

import '../models/neighborhood.dart';
import '../models/report_category.dart';
import '../repositories/report_repository.dart';
import '../widgets/category_selector.dart';
import '../widgets/field_error_text.dart';
import '../widgets/section_title.dart';
import 'neighborhoods_screen.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({super.key});

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final ReportRepository _repository = ReportRepository.instance;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  ReportCategory? _category;
  String? _neighborhood;
  bool _tried = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();

    super.dispose();
  }

  Future<void> _chooseNeighborhood() async {
    final result = await Navigator.push<Neighborhood>(
      context,
      MaterialPageRoute(
        builder: (context) => NeighborhoodsScreen(
          selectedNeighborhood: _neighborhood,
        ),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        _neighborhood = result.name;
      });
    }
  }

  void _submit() {
    setState(() {
      _tried = true;
    });

    final isValid = _formKey.currentState!.validate();

    if (!isValid || _category == null || _neighborhood == null) {
      return;
    }

    final report = _repository.add(
      title: _titleController.text,
      description: _descriptionController.text,
      category: _category!,
      neighborhood: _neighborhood!,
    );

    // Devolve o relato criado para a tela anterior.
    Navigator.pop(context, report);
  }

  String? _validateRequired(String? value, String field) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe $field';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo relato')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const SectionTitle('Qual é o problema?'),
            CategorySelector(
              selected: _category,
              onSelect: (category) {
                setState(() {
                  _category = category;
                });
              },
            ),
            if (_tried && _category == null)
              const FieldErrorText('Escolha uma categoria'),
            const SizedBox(height: 24),
            const SectionTitle('Onde?'),
            OutlinedButton.icon(
              onPressed: _chooseNeighborhood,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.centerLeft,
              ),
              icon: const Icon(Icons.place),
              label: Text(_neighborhood ?? 'Escolher bairro'),
            ),
            if (_tried && _neighborhood == null)
              const FieldErrorText('Escolha o bairro'),
            const SizedBox(height: 24),
            const SectionTitle('Detalhes'),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ex.: Esgoto vazando na calçada',
              ),
              validator: (value) => _validateRequired(value, 'um título'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Conte o que está acontecendo e há quanto tempo',
                alignLabelWithHint: true,
              ),
              validator: (value) => _validateRequired(value, 'uma descrição'),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.send),
              label: const Text('Enviar relato'),
            ),
          ],
        ),
      ),
    );
  }
}
