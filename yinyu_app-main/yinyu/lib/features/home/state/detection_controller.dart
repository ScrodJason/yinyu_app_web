import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/random_utils.dart';
import 'detection_models.dart';

class DetectionState {
  final bool deviceConnected;
  final List<DetectionSession> sessions;

  const DetectionState({required this.deviceConnected, required this.sessions});

  DetectionState copyWith({bool? deviceConnected, List<DetectionSession>? sessions}) {
    return DetectionState(
      deviceConnected: deviceConnected ?? this.deviceConnected,
      sessions: sessions ?? this.sessions,
    );
  }

  factory DetectionState.initial() => const DetectionState(deviceConnected: false, sessions: []);
}

class DetectionController extends StateNotifier<DetectionState> {
  DetectionController() : super(DetectionState.initial());

  void toggleDevice() => state = state.copyWith(deviceConnected: !state.deviceConnected);

  DetectionSession runMockDetection() {
    final label = RandomUtils.pick(['平静', '轻度波动', '压力偏高', '情绪低落']);
    final stress = RandomUtils.nextDouble(0.15, 0.95);
    final arousal = RandomUtils.nextDouble(0.12, 0.92);

    final s = DetectionSession(
      id: 'd_${DateTime.now().millisecondsSinceEpoch}',
      at: DateTime.now(),
      emotionLabel: label,
      stress: stress,
      arousal: arousal,
      sparkline: RandomUtils.sparkline(),
    );
    state = state.copyWith(sessions: [s, ...state.sessions]);
    return s;
  }
}

final detectionControllerProvider =
    StateNotifierProvider<DetectionController, DetectionState>((ref) => DetectionController());
