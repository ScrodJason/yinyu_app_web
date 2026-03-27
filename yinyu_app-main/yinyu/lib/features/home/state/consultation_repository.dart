import 'consultation_models.dart';

class ConsultationRepository {
  const ConsultationRepository();

  static const consultants = <Consultant>[
    Consultant(id: 'c1', name: '林老师', title: '国家二级心理咨询师', rating: 4.8, cases: 1200, specialties: ['学业压力', '情绪管理', '失眠']),
    Consultant(id: 'c2', name: '周医生', title: '精神科主治医师', rating: 4.7, cases: 860, specialties: ['抑郁干预', '焦虑', '药物咨询(科普)']),
    Consultant(id: 'c3', name: '赵老师', title: '音乐治疗师', rating: 4.9, cases: 540, specialties: ['音乐疗法', '冥想引导', '躯体放松']),
  ];

  Consultant byId(String id) => consultants.firstWhere((e) => e.id == id, orElse: () => consultants.first);
}
