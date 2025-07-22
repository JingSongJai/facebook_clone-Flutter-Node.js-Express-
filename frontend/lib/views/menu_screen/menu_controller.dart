import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/views/friend_screen/friend_screen.dart';
import 'package:facebook_clone/views/home_screen/home_screen.dart';
import 'package:facebook_clone/views/notification_screen/notification_screen.dart';
import 'package:facebook_clone/views/profile_screen/profile_screen.dart';
import 'package:facebook_clone/views/setting_screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final selectedIndex = 0.obs;

  final tabs = [
    Icon(Icons.home),
    Icon(Icons.movie_outlined),
    Icon(Icons.people_alt_outlined),
    Icon(Icons.person_outline),
    Icon(Icons.notifications_outlined),
  ];

  final webTabs = [
    Icons.home_rounded,
    Icons.movie_rounded,
    Icons.shopping_bag_rounded,
    Icons.games_rounded,
  ];

  final views = [
    HomeScreen(),
    HomeScreen(),
    FriendScreen(),
    ProfileScreen(),
    NotificationScreen(),
    SettingScreen(),
  ];

  @override
  void onInit() {
    tabController = TabController(length: 6, vsync: this);

    super.onInit();
  }

  Widget getIcon(int index) {
    switch (index) {
      case 0:
        return selectedIndex.value == 0
            ? Icon(Icons.home)
            : Icon(Icons.home_outlined);

      case 1:
        return selectedIndex.value == 1
            ? Icon(Icons.movie)
            : Icon(Icons.movie_outlined);

      case 2:
        return selectedIndex.value == 2
            ? Icon(Icons.people_alt)
            : Icon(Icons.people_alt_outlined);

      case 3:
        return selectedIndex.value == 3
            ? Icon(Icons.person)
            : Icon(Icons.person_outlined);

      case 4:
        return selectedIndex.value == 4
            ? Icon(Icons.notifications)
            : Icon(Icons.notifications_outlined);

      default:
        return selectedIndex.value == 5
            ? Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: NetworkImage(AuthService.to.user!.avatarUrl),
                radius: 13,
              ),
            )
            : Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                backgroundImage: NetworkImage(AuthService.to.user!.avatarUrl),
                radius: 13,
              ),
            );
    }
  }

  @override
  void onReady() {
    super.onReady();
    tabController.addListener(() {
      selectedIndex.value = tabController.index;
    });
  }
}
