import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/services/online_service.dart';
import 'package:facebook_clone/views/profile_screen/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyFriendWidget extends StatelessWidget {
  const MyFriendWidget({super.key, required this.user});
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          AppPage.profile,
          parameters: {'id': user.id},
          arguments: user,
        );
        Get.find<ProfileController>()
          ..getFriends(user.id)
          ..getPosts()
          ..user.value = user;
      },
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
              child: Image.network(user.avatarUrl, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                if (user.matualCount != 0)
                  Text(
                    '${user.matualCount} matual friends',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                Obx(
                  () =>
                      Get.find<OnlineService>().ids.contains(user.id)
                          ? Row(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.circle,
                                color: Colors.green.shade700,
                                size: 10,
                              ),
                              Text(
                                'Active now',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
