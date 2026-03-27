import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'consultation_repository.dart';
import 'consultation_models.dart';

final consultationRepositoryProvider = Provider<ConsultationRepository>((ref) => const ConsultationRepository());

final consultantsProvider = Provider<List<Consultant>>((ref) => ConsultationRepository.consultants);

final consultantByIdProvider = Provider.family<Consultant, String>((ref, id) {
  final repo = ref.watch(consultationRepositoryProvider);
  return repo.byId(id);
});
