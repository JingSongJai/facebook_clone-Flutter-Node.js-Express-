import 'dart:async';

import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/services/online_service.dart';
import 'package:facebook_clone/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ViewFriendController extends GetxController {
  final friends = <UserModel>[].obs;
  final isLoading = false.obs;
  final text = ''.obs;

  late final String type;
  String title = 'Your friends';
  final textController = TextEditingController();
  Timer? timer;
  final sorts = ['Default', 'Newest friend first', 'Oldest friend first'];
  int? sort;

  @override
  void onInit() async {
    type = Get.parameters['type'] ?? 'online_friend';
    await getFriends();
    ever(Get.find<OnlineService>().ids, (_) async {
      if (title == 'Online friends') {
        await getOnlineFriends();
      }
    });

    debounce(text, (_) async {
      debugPrint('New Value : $text');
      await getFriends();
    }, time: 1.seconds);

    super.onInit();
  }

  Future<void> getFriends() async {
    isLoading.value = true;
    switch (type) {
      case 'online_friend':
        title = 'Online friends';
        await getOnlineFriends();
        break;
      case 'request_friend':
        title = 'Request friends';
        friends.value = await UserService().getUsers(
          request: true,
          name: text.value,
          sort: sort,
        );
        break;
      case 'your_friend':
        title = 'Your friends';
        friends.value = await UserService().getUsers(
          friend: true,
          name: text.value,
          sort: sort,
        );
        break;
    }
    isLoading.value = false;
  }

  Future<void> getOnlineFriends() async {
    List<UserModel> temp = [];
    for (String id in Get.find<OnlineService>().ids) {
      final user = await UserService().profile(id);
      if (user != null) {
        temp.add(user);
      }
    }
    friends.value = temp;
  }

  void searchDebounce() {
    timer?.cancel();

    timer = Timer(const Duration(seconds: 2), () async {
      debugPrint('New Value : $text');
      await getFriends();
    });
  }
}
