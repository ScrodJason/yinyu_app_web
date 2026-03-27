class UserProfile {
  final String id;
  final String phone;
  final String nickname;
  final int age;
  final String gender;
  final List<String> tags;

  const UserProfile({
    required this.id,
    required this.phone,
    required this.nickname,
    required this.age,
    required this.gender,
    required this.tags,
  });

  UserProfile copyWith({
    String? nickname,
    int? age,
    String? gender,
    List<String>? tags,
  }) {
    return UserProfile(
      id: id,
      phone: phone,
      nickname: nickname ?? this.nickname,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      tags: tags ?? this.tags,
    );
  }
}
