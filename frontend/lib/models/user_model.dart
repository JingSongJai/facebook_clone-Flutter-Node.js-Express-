import 'package:facebook_clone/utils/utils.dart';

class UserModel {
  final String id;
  final String username;
  final String bio;
  final String avatarUrl;
  final List<FriendModel>? friends;
  final String? coverUrl;
  int matualCount = 0;

  UserModel({
    required this.id,
    required this.username,
    required this.bio,
    required this.avatarUrl,
    this.friends,
    required this.coverUrl,
    required this.matualCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'friends': friends,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      bio: json['bio'] ?? '',
      avatarUrl: json['avatarUrl'],
      friends:
          json['friends'] != null
              ? ((json['friends'] ?? []) as List)
                  .map((friend) => FriendModel.fromJson(friend))
                  .toList()
              : null,
      coverUrl: json['coverUrl'],
      matualCount: json['matualCount'] ?? 0,
    );
  }
}

class FriendModel {
  final String? status;
  final bool? request;
  final UserModel? user;
  final DateTime? createdAt;
  final String? duration;

  FriendModel({
    required this.status,
    required this.request,
    required this.user,
    required this.createdAt,
    required this.duration,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'request': request,
      'user': user?.toJson(),
      'createdAt': createdAt,
    };
  }

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      status: json['status'] ?? '',
      request: json['request'],
      user: UserModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['createdAt']),
      duration: Utils.durationAgo(
        DateTime.parse(json['createdAt']),
        DateTime.now(),
      ),
    );
  }
}
