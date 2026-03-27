class Post {
  final String id;
  final String author;
  final DateTime at;
  final String content;
  final int likes;
  final int comments;
  final int shares;
  final bool liked;

  const Post({
    required this.id,
    required this.author,
    required this.at,
    required this.content,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.liked,
  });

  Post copyWith({int? likes, int? comments, int? shares, bool? liked}) {
    return Post(
      id: id,
      author: author,
      at: at,
      content: content,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      liked: liked ?? this.liked,
    );
  }
}

class Article {
  final String id;
  final String title;
  final DateTime at;
  final int views;
  final int comments;

  const Article({required this.id, required this.title, required this.at, required this.views, required this.comments});
}

class Video {
  final String id;
  final String title;
  final String topic;
  final int likes;

  const Video({required this.id, required this.title, required this.topic, required this.likes});
}

class Circle {
  final String id;
  final String name;
  final int members;
  final int todayCheckins;

  const Circle({required this.id, required this.name, required this.members, required this.todayCheckins});

  Circle copyWith({int? todayCheckins}) => Circle(
        id: id,
        name: name,
        members: members,
        todayCheckins: todayCheckins ?? this.todayCheckins,
      );
}
