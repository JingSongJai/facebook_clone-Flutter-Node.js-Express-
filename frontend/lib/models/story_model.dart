import 'package:facebook_clone/models/user_model.dart';

class StoryModel {
  final String id;
  final UserModel user;
  final String image;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  StoryModel({
    required this.id,
    required this.user,
    required this.image,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {'_id ': id, 'image': image};
  }

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] ?? 0,
      user: UserModel.fromJson(json['user']),
      image: json['image'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
      updatedAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}
