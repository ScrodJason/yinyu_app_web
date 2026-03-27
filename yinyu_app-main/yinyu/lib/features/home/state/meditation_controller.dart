import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'meditation_models.dart';

class MeditationState {
  final List<MeditationRecord> records;

  const MeditationState({required this.records});

  factory MeditationState.initial() => const MeditationState(records: []);

  MeditationState copyWith({List<MeditationRecord>? records}) => MeditationState(records: records ?? this.records);
}

class MeditationController extends StateNotifier<MeditationState> {
  MeditationController() : super(MeditationState.initial());

  void addRecord({required int minutes, required String preset}) {
    final r = MeditationRecord(
      id: 'm_${DateTime.now().millisecondsSinceEpoch}',
      at: DateTime.now(),
      minutes: minutes,
      preset: preset,
    );
    state = state.copyWith(records: [r, ...state.records]);
  }
}

final meditationControllerProvider =
    StateNotifierProvider<MeditationController, MeditationState>((ref) => MeditationController());
