import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/community_models.dart';

class CommunityState {
  final String query;
  final List<Post> posts;
  final List<Article> articles;
  final List<Video> videos;
  final List<Circle> circles;

  const CommunityState({
    required this.query,
    required this.posts,
    required this.articles,
    required this.videos,
    required this.circles,
  });

  factory CommunityState.initial() => CommunityState(
        query: '',
        posts: [
          Post(
            id: 'p1',
            author: '音友A',
            at: DateTime.now(),
            content: '今天做了 15 分钟冥想挑战，配合雨声真的很放松。',
            likes: 32,
            comments: 6,
            shares: 2,
            liked: false,
          ),
          Post(
            id: 'p2',
            author: '音友B',
            at: DateTime.now().subtract(const Duration(hours: 3)),
            content: '考试周压力好大，准备今晚试试“缓解焦虑专题”。',
            likes: 18,
            comments: 3,
            shares: 1,
            liked: true,
          ),
        ],
        articles: [
          Article(id: 'a1', title: '情绪管理：如何识别压力信号', at: DateTime.now().subtract(const Duration(days: 1)), views: 2301, comments: 23),
          Article(id: 'a2', title: '冥想入门：15 分钟也有效', at: DateTime.now().subtract(const Duration(days: 2)), views: 1820, comments: 11),
          Article(id: 'a3', title: '音乐疗法科普：为什么旋律能影响情绪', at: DateTime.now().subtract(const Duration(days: 4)), views: 3210, comments: 44),
        ],
        videos: [
          Video(id: 'v1', title: '抑郁症科普：常见误区', topic: '抑郁科普', likes: 1200),
          Video(id: 'v2', title: '如何调整情绪：呼吸练习', topic: '情绪调节', likes: 980),
          Video(id: 'v3', title: '音友日常：我的助眠歌单', topic: '音友日常', likes: 650),
        ],
        circles: const [
          Circle(id: 'c1', name: '每日 15 分钟打卡', members: 1280, todayCheckins: 312),
          Circle(id: 'c2', name: '考试周减压互助', members: 540, todayCheckins: 88),
        ],
      );

  CommunityState copyWith({
    String? query,
    List<Post>? posts,
    List<Article>? articles,
    List<Video>? videos,
    List<Circle>? circles,
  }) {
    return CommunityState(
      query: query ?? this.query,
      posts: posts ?? this.posts,
      articles: articles ?? this.articles,
      videos: videos ?? this.videos,
      circles: circles ?? this.circles,
    );
  }
}

class CommunityController extends StateNotifier<CommunityState> {
  CommunityController() : super(CommunityState.initial());

  void setQuery(String q) => state = state.copyWith(query: q);

  void addPost({required String author, required String content}) {
    final p = Post(
      id: 'p_${DateTime.now().millisecondsSinceEpoch}',
      author: author,
      at: DateTime.now(),
      content: content,
      likes: 0,
      comments: 0,
      shares: 0,
      liked: false,
    );
    state = state.copyWith(posts: [p, ...state.posts]);
  }

  void toggleLike(String postId) {
    final updated = state.posts.map((p) {
      if (p.id != postId) return p;
      final liked = !p.liked;
      return p.copyWith(liked: liked, likes: liked ? p.likes + 1 : (p.likes - 1).clamp(0, 1 << 30));
    }).toList();
    state = state.copyWith(posts: updated);
  }

  void share(String postId) {
    final updated = state.posts.map((p) {
      if (p.id != postId) return p;
      return p.copyWith(shares: p.shares + 1);
    }).toList();
    state = state.copyWith(posts: updated);
  }

  void checkin(String circleId) {
    final updated = state.circles.map((c) {
      if (c.id != circleId) return c;
      return c.copyWith(todayCheckins: c.todayCheckins + 1);
    }).toList();
    state = state.copyWith(circles: updated);
  }
}

final communityControllerProvider =
    StateNotifierProvider<CommunityController, CommunityState>((ref) => CommunityController());
