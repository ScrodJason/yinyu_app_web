class DetectionSession {
  final String id;
  final DateTime at;
  final String emotionLabel;
  final double stress;
  final double arousal;
  final List<double> sparkline;

  const DetectionSession({
    required this.id,
    required this.at,
    required this.emotionLabel,
    required this.stress,
    required this.arousal,
    required this.sparkline,
  });
}
