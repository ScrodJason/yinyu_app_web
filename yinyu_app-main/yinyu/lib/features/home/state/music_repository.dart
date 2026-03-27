import 'music_models.dart';

class MusicRepository {
  const MusicRepository();

  static const tracks = <Track>[
    Track(id: 't1', title: '雨声 · 轻柔', artist: '自然音景', duration: Duration(minutes: 6, seconds: 12), tags: ['自然音景', '助眠', '冥想专用']),
    Track(id: 't2', title: '白噪音 · 深度专注', artist: '白噪音', duration: Duration(minutes: 8, seconds: 5), tags: ['白噪音', '减压']),
    Track(id: 't3', title: '海浪 · 呼吸节律', artist: '自然音景', duration: Duration(minutes: 5, seconds: 40), tags: ['自然音景', '放松类']),
    Track(id: 't4', title: '治愈钢琴 · 暮色', artist: '轻音乐', duration: Duration(minutes: 4, seconds: 30), tags: ['治愈系', '放松类']),
    Track(id: 't5', title: '助眠频率 · 432Hz', artist: '疗愈音阶', duration: Duration(minutes: 7, seconds: 18), tags: ['助眠', '冥想专用']),
    Track(id: 't6', title: '焦虑缓解 · 温柔和弦', artist: '治愈系', duration: Duration(minutes: 5, seconds: 55), tags: ['缓解焦虑', '治愈系']),
    Track(id: 't7', title: '森林 · 清晨鸟鸣', artist: '自然音景', duration: Duration(minutes: 6, seconds: 20), tags: ['自然音景', '积极']),
    Track(id: 't8', title: '夜行 · 低频氛围', artist: '冥想', duration: Duration(minutes: 9, seconds: 10), tags: ['冥想专用', '减压']),
  ];

  Track byId(String id) => tracks.firstWhere((e) => e.id == id, orElse: () => tracks.first);
}
