class MeditationRecord {
  final String id;
  final DateTime at;
  final int minutes;
  final String preset;

  const MeditationRecord({required this.id, required this.at, required this.minutes, required this.preset});
}
