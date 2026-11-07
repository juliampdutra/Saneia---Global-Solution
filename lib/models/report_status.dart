enum ReportStatus {
  open('Aberto'),
  inReview('Em análise'),
  resolved('Resolvido');

  const ReportStatus(this.label);

  final String label;
}
