import 'package:facebook_clone/models/user_model.dart';

class PostModel {
  final String id;
  final UserModel user;
  final String text;
  final List<String> imageUrls;
  final List<LikeModel> likes;
  final List<CommentModel> comments;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostModel({
    required this.id,
    required this.user,
    required this.text,
    required this.imageUrls,
    required this.likes,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user': user.toJson(),
      'text': text,
      'imageUrls': imageUrls,
      'likes': likes.map((x) => x.toJson()).toList(),
      'comments': comments.map((x) => x.toJson()).toList(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory PostModel.fromJson(Map<String, dynamic> map) {
    return PostModel(
      id: map['_id'] ?? '',
      user: UserModel.fromJson(map['user'] as Map<String, dynamic>),
      text: map['text'] ?? '',
      imageUrls:
          (map['imageUrls'] as List).map((image) => image.toString()).toList(),
      likes:
          (map['likes'] as List)
              .map((like) => LikeModel.fromJson(like))
              .toList(),
      comments:
          (map['comments'] as List)
              .map((comment) => CommentModel.fromJson(comment))
              .toList(),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

class LikeModel {
  final String id;
  final UserModel user;
  final String reactType;

  LikeModel({required this.id, required this.user, required this.reactType});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'user': user.toJson(),
      'reactType': reactType,
    };
  }

  factory LikeModel.fromJson(Map<String, dynamic> map) {
    return LikeModel(
      id: map['_id'] ?? '',
      user: UserModel.fromJson(map['user'] as Map<String, dynamic>),
      reactType: map['reactType'] ?? '',
    );
  }
}

class CommentModel {
  final String id;
  final UserModel user;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'id': id, 'user': user.toJson(), 'text': text};
  }

  factory CommentModel.fromJson(Map<String, dynamic> map) {
    return CommentModel(
      id: map['_id'] ?? '',
      user: UserModel.fromJson(map['user'] as Map<String, dynamic>),
      text: map['text'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
