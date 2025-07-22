import 'package:facebook_clone/models/user_model.dart';

class NotificationModel {
  final bool isRead;
  final UserModel from;
  final String notifyType;
  final String message;
  final DateTime createdAt;

  NotificationModel({
    required this.isRead,
    required this.from,
    required this.notifyType,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'isRead': isRead,
      'from': from.toJson(),
      'notifyType': notifyType,
      'message': message,
      'createdAt': createdAt,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      isRead: json['isRead'] ?? false,
      from: UserModel.fromJson(json['from']),
      notifyType: json['notifyType'],
      message: json['message'],
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}
