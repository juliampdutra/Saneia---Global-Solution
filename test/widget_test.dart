import 'package:flutter_test/flutter_test.dart';
import 'package:saneia/models/neighborhood.dart';
import 'package:saneia/models/priority_level.dart';
import 'package:saneia/models/report.dart';
import 'package:saneia/models/report_category.dart';
import 'package:saneia/models/report_status.dart';
import 'package:saneia/repositories/report_repository.dart';

void main() {
  test('Neighborhood é convertido a partir do JSON do IBGE', () {
    final neighborhood = Neighborhood.fromJson({
      'id': 355030801,
      'nome': 'Água Rasa',
      'municipio': {'id': 3550308, 'nome': 'São Paulo'},
    });

    expect(neighborhood.id, 355030801);
    expect(neighborhood.name, 'Água Rasa');
    expect(neighborhood.city, 'São Paulo');
  });

  test('Filtro por categoria retorna apenas a categoria escolhida', () {
    final reports = ReportRepository.instance.list(
      category: ReportCategory.leak,
    );

    expect(reports, isNotEmpty);
    expect(reports.every((r) => r.category == ReportCategory.leak), isTrue);
  });

  test('Relato resolvido tem prioridade zero', () {
    final report = Report(
      id: 'teste-1',
      title: 'Teste',
      description: 'Teste',
      category: ReportCategory.sewage,
      neighborhood: 'Sé',
      createdAt: DateTime.now(),
      status: ReportStatus.resolved,
      confirmations: 10,
    );

    expect(ReportRepository.instance.calculatePriority(report), 0);
    expect(
      ReportRepository.instance.priorityLevel(report),
      PriorityLevel.low,
    );
  });

  test('Confirmar um relato soma e desfazer subtrai uma confirmação', () {
    final report = Report(
      id: 'teste-2',
      title: 'Teste',
      description: 'Teste',
      category: ReportCategory.drain,
      neighborhood: 'Sé',
      createdAt: DateTime.now(),
      confirmations: 4,
    );

    ReportRepository.instance.toggleConfirmation(report);
    expect(report.confirmations, 5);
    expect(report.confirmedByMe, isTrue);

    ReportRepository.instance.toggleConfirmation(report);
    expect(report.confirmations, 4);
    expect(report.confirmedByMe, isFalse);
  });

  test('Novo relato entra na lista e é encontrado pela busca', () {
    final report = ReportRepository.instance.add(
      title: '  Bueiro na Rua Teste  ',
      description: 'Entupido',
      category: ReportCategory.drain,
      neighborhood: 'Sé',
    );

    expect(report.title, 'Bueiro na Rua Teste');

    final found = ReportRepository.instance.list(search: 'rua teste');
    expect(found.any((r) => r.id == report.id), isTrue);
  });
}
