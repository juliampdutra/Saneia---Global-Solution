import '../models/priority_level.dart';
import '../models/report.dart';
import '../models/report_category.dart';
import '../models/report_status.dart';

/// Acesso aos relatos e regras de negócio (filtro, prioridade, confirmação).
/// Os dados ficam em memória enquanto o aplicativo está aberto.
class ReportRepository {
  ReportRepository._();

  static final ReportRepository instance = ReportRepository._();

  final List<Report> _reports = _initialReports();
  int _nextId = 100;

  /// Lista os relatos aplicando os filtros, ordenados por prioridade.
  List<Report> list({
    ReportCategory? category,
    String? neighborhood,
    String search = '',
  }) {
    final term = search.trim().toLowerCase();

    final result = _reports.where((report) {
      final matchesCategory = category == null || report.category == category;
      final matchesNeighborhood =
          neighborhood == null || report.neighborhood == neighborhood;
      final matchesSearch = term.isEmpty ||
          report.title.toLowerCase().contains(term) ||
          report.description.toLowerCase().contains(term) ||
          report.neighborhood.toLowerCase().contains(term);

      return matchesCategory && matchesNeighborhood && matchesSearch;
    }).toList();

    result.sort(
      (a, b) => calculatePriority(b).compareTo(calculatePriority(a)),
    );

    return result;
  }

  /// Prioridade = gravidade da categoria + confirmações da vizinhança + tempo aberto.
  /// Relatos resolvidos vão para o fim da lista.
  int calculatePriority(Report report) {
    if (report.status == ReportStatus.resolved) {
      return 0;
    }

    return report.category.severity * 10 +
        report.confirmations * 2 +
        report.daysOpen;
  }

  PriorityLevel priorityLevel(Report report) {
    final priority = calculatePriority(report);

    if (priority >= 60) {
      return PriorityLevel.high;
    }

    if (priority >= 30) {
      return PriorityLevel.medium;
    }

    return PriorityLevel.low;
  }

  /// Quantidade de relatos em cada status (usada nos indicadores da Home).
  int countByStatus(ReportStatus status) {
    return _reports.where((report) => report.status == status).length;
  }

  void toggleConfirmation(Report report) {
    if (report.confirmedByMe) {
      report.confirmedByMe = false;
      report.confirmations--;
    } else {
      report.confirmedByMe = true;
      report.confirmations++;
    }
  }

  Report add({
    required String title,
    required String description,
    required ReportCategory category,
    required String neighborhood,
  }) {
    final report = Report(
      id: (_nextId++).toString(),
      title: title.trim(),
      description: description.trim(),
      category: category,
      neighborhood: neighborhood,
      createdAt: DateTime.now(),
    );

    _reports.insert(0, report);

    return report;
  }

  static List<Report> _initialReports() {
    final today = DateTime.now();

    return [
      Report(
        id: '1',
        title: 'Esgoto vazando na calçada',
        description:
            'Há meses o esgoto escorre pela calçada em frente ao número 120. '
            'O cheiro é forte e as crianças passam por ali para ir à escola.',
        category: ReportCategory.sewage,
        neighborhood: 'Itaim Paulista',
        createdAt: today.subtract(const Duration(days: 45)),
        confirmations: 12,
      ),
      Report(
        id: '2',
        title: 'Cano estourado na esquina',
        description:
            'Água limpa jorrando desde ontem à noite na esquina da praça.',
        category: ReportCategory.leak,
        neighborhood: 'Guaianases',
        createdAt: today.subtract(const Duration(days: 2)),
        status: ReportStatus.inReview,
        confirmations: 5,
      ),
      Report(
        id: '3',
        title: 'Rua sem água há 3 dias',
        description:
            'Vários moradores da rua estão sem água desde segunda-feira.',
        category: ReportCategory.noWater,
        neighborhood: 'Cidade Tiradentes',
        createdAt: today.subtract(const Duration(days: 3)),
        confirmations: 8,
      ),
      Report(
        id: '4',
        title: 'Bueiro entupido alaga a rua',
        description: 'Toda chuva a rua alaga porque o bueiro está cheio de lixo.',
        category: ReportCategory.drain,
        neighborhood: 'Capão Redondo',
        createdAt: today.subtract(const Duration(days: 20)),
        confirmations: 3,
      ),
      Report(
        id: '5',
        title: 'Esgoto a céu aberto no córrego',
        description:
            'Ligação de esgoto despejando direto no córrego atrás das casas.',
        category: ReportCategory.sewage,
        neighborhood: 'Brasilândia',
        createdAt: today.subtract(const Duration(days: 60)),
        status: ReportStatus.resolved,
        confirmations: 15,
      ),
    ];
  }
}
