import 'report_category.dart';
import 'report_status.dart';

class Report {
  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.neighborhood,
    required this.createdAt,
    this.status = ReportStatus.open,
    this.confirmations = 0,
    this.confirmedByMe = false,
  });

  final String id;
  final String title;
  final String description;
  final ReportCategory category;
  final String neighborhood;
  final DateTime createdAt;

  ReportStatus status;
  int confirmations;
  bool confirmedByMe;

  int get daysOpen => DateTime.now().difference(createdAt).inDays;
}
