import 'package:flutter/material.dart';

import '../models/neighborhood.dart';
import '../models/report.dart';
import '../models/report_category.dart';
import '../models/report_status.dart';
import '../repositories/report_repository.dart';
import '../theme/app_colors.dart';
import '../widgets/category_selector.dart';
import '../widgets/logo_badge.dart';
import '../widgets/report_card.dart';
import '../widgets/state_message.dart';
import '../widgets/stats_board.dart';
import 'neighborhoods_screen.dart';
import 'new_report_screen.dart';
import 'report_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ReportRepository _repository = ReportRepository.instance;
  final TextEditingController _searchController = TextEditingController();

  ReportCategory? _selectedCategory;
  String? _selectedNeighborhood;

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  List<Report> get _reports {
    return _repository.list(
      category: _selectedCategory,
      neighborhood: _selectedNeighborhood,
      search: _searchController.text,
    );
  }

  Future<void> _openDetail(Report report) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportDetailScreen(report: report),
      ),
    );

    if (!mounted) return;

    // Atualiza a lista caso o usuário tenha confirmado o relato no detalhe.
    setState(() {});
  }

  Future<void> _openNewReport() async {
    final result = await Navigator.push<Report>(
      context,
      MaterialPageRoute(
        builder: (context) => const NewReportScreen(),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Relato "${result.title}" enviado!')),
      );
    }
  }

  Future<void> _filterByNeighborhood() async {
    final result = await Navigator.push<Neighborhood>(
      context,
      MaterialPageRoute(
        builder: (context) => NeighborhoodsScreen(
          selectedNeighborhood: _selectedNeighborhood,
        ),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() {
        _selectedNeighborhood = result.name;
      });
    }
  }

  void _confirmReport(Report report) {
    setState(() {
      _repository.toggleConfirmation(report);
    });
  }

  void _clearFilters() {
    _searchController.clear();

    setState(() {
      _selectedCategory = null;
      _selectedNeighborhood = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final reports = _reports;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            LogoBadge(size: 34),
            SizedBox(width: 10),
            Text('Saneia'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Filtrar por bairro',
            onPressed: _filterByNeighborhood,
            icon: const Icon(Icons.location_city),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewReport,
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Reportar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: StatsBoard(
              open: _repository.countByStatus(ReportStatus.open),
              inReview: _repository.countByStatus(ReportStatus.inReview),
              resolved: _repository.countByStatus(ReportStatus.resolved),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Buscar relatos',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();

                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
          CategorySelector(
            showAll: true,
            horizontal: true,
            selected: _selectedCategory,
            onSelect: (category) {
              setState(() {
                _selectedCategory = category;
              });
            },
          ),
          if (_selectedNeighborhood != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: InputChip(
                avatar: const Icon(Icons.place, size: 18),
                label: Text(_selectedNeighborhood!),
                onDeleted: () {
                  setState(() {
                    _selectedNeighborhood = null;
                  });
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              '${reports.length} relato(s) · ordenados por prioridade',
              style: const TextStyle(color: AppColors.secondaryText),
            ),
          ),
          Expanded(
            child: reports.isEmpty
                ? StateMessage(
                    icon: Icons.search_off,
                    title: 'Nenhum relato encontrado',
                    message: 'Tente mudar a busca ou os filtros.',
                    buttonText: 'Limpar filtros',
                    onPressed: _clearFilters,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                    itemCount: reports.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 10);
                    },
                    itemBuilder: (context, index) {
                      final report = reports[index];

                      return ReportCard(
                        report: report,
                        priority: _repository.priorityLevel(report),
                        onTap: () => _openDetail(report),
                        onConfirm: () => _confirmReport(report),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
