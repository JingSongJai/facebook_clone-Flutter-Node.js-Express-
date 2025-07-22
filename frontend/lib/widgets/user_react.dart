import 'package:facebook_clone/models/post_model.dart';
import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/views/profile_screen/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserReactWidget extends StatelessWidget {
  const UserReactWidget({super.key, required this.like});
  final LikeModel like;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          AppPage.profile,
          parameters: {'id': like.user.id},
          arguments: like.user,
        );
        Get.find<ProfileController>()
          ..getFriends(like.id)
          ..getPosts()
          ..user.value = like.user;
      },
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Stack(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(like.user.avatarUrl),
                  radius: 20,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    'assets/icons/${like.reactType}-active.png',
                    width: 35,
                    height: 35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            like.user.username,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
