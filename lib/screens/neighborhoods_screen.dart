import 'package:flutter/material.dart';

import '../models/neighborhood.dart';
import '../models/view_state.dart';
import '../services/api_exception.dart';
import '../services/ibge_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_card.dart';
import '../widgets/state_message.dart';

/// Lista os bairros (distritos) de São Paulo vindos da API do IBGE.
/// Ao tocar em um bairro, ele é devolvido para a tela anterior.
class NeighborhoodsScreen extends StatefulWidget {
  final String? selectedNeighborhood;

  const NeighborhoodsScreen({super.key, this.selectedNeighborhood});

  @override
  State<NeighborhoodsScreen> createState() => _NeighborhoodsScreenState();
}

class _NeighborhoodsScreenState extends State<NeighborhoodsScreen> {
  final IbgeService _service = IbgeService();
  final TextEditingController _searchController = TextEditingController();

  ViewState _state = ViewState.initial;
  List<Neighborhood> _neighborhoods = [];
  String _errorMessage = '';

  @override
  void dispose() {
    _searchController.dispose();

    super.dispose();
  }

  Future<void> _loadNeighborhoods({bool showLoading = true}) async {
    // No "puxar para atualizar" o próprio RefreshIndicator já mostra o
    // carregamento, então a lista não precisa ser trocada pelo spinner.
    if (showLoading) {
      setState(() {
        _state = ViewState.loading;
      });
    }

    try {
      final result = await _service.getNeighborhoods();

      if (!mounted) return;

      setState(() {
        _neighborhoods = result;
        _state = ViewState.success;
      });
    } on ApiException catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = error.message;
        _state = ViewState.error;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Ocorreu um erro inesperado. Tente novamente.';
        _state = ViewState.error;
      });
    }
  }

  List<Neighborhood> get _filteredNeighborhoods {
    final term = _searchController.text.trim().toLowerCase();

    if (term.isEmpty) {
      return _neighborhoods;
    }

    return _neighborhoods
        .where((neighborhood) => neighborhood.name.toLowerCase().contains(term))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bairros de São Paulo'),
        actions: [
          if (_state == ViewState.success)
            IconButton(
              tooltip: 'Atualizar',
              onPressed: () => _loadNeighborhoods(),
              icon: const Icon(Icons.refresh),
            ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    switch (_state) {
      case ViewState.initial:
        return StateMessage(
          icon: Icons.location_city,
          title: 'Bairros da cidade',
          message: 'Carregue a lista oficial de bairros (distritos) de '
              'São Paulo, fornecida pelo IBGE.',
          buttonText: 'Carregar bairros',
          onPressed: () => _loadNeighborhoods(),
        );
      case ViewState.loading:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Buscando bairros...'),
            ],
          ),
        );
      case ViewState.error:
        return StateMessage(
          icon: Icons.cloud_off,
          iconColor: AppColors.error,
          title: 'Não foi possível carregar',
          message: _errorMessage,
          buttonText: 'Tentar novamente',
          onPressed: () => _loadNeighborhoods(),
        );
      case ViewState.success:
        return _buildList();
    }
  }

  Widget _buildList() {
    final neighborhoods = _filteredNeighborhoods;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: 'Buscar bairro',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _loadNeighborhoods(showLoading: false),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: neighborhoods.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 8);
              },
              itemBuilder: (context, index) {
                final neighborhood = neighborhoods[index];
                final isSelected =
                    neighborhood.name == widget.selectedNeighborhood;

                return AppCard(
                  padding: EdgeInsets.zero,
                  child: ListTile(
                    leading: Icon(
                      Icons.place,
                      color:
                          isSelected ? AppColors.secondary : AppColors.primary,
                    ),
                    title: Text(neighborhood.name),
                    subtitle: Text(neighborhood.city),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.secondary,
                          )
                        : const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pop(context, neighborhood),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
