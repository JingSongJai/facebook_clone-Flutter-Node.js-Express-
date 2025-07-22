import 'package:facebook_clone/models/notification_model.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.notify});
  final NotificationModel notify;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      color: notify.isRead ? color.surface : color.primary.withAlpha(10),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(notify.from.avatarUrl),
            radius: 35,
          ),
          Text(notify.message),
        ],
      ),
    );
  }
}
