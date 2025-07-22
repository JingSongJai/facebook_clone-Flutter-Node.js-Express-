import 'package:facebook_clone/controllers/request_controller.dart';
import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/services/user_service.dart';
import 'package:facebook_clone/views/profile_screen/profile_controller.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FriendRequestWidget extends GetView<RequestController> {
  FriendRequestWidget({super.key, required this.user, this.isOther = true});

  final UserModel user;
  final isAdded = RxnBool(null);
  final isLoading = false.obs;
  final userService = UserService();
  final bool isOther;

  final meRequested = RxnBool(null);
  final isConfirmed = RxnBool(null);
  final isCanceled = false.obs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    meRequested.value =
        (user.friends ?? [])
            .singleWhere(
              (friend) => friend.user?.id == Get.find<AuthService>().user?.id,
              orElse:
                  () => FriendModel(
                    createdAt: null,
                    duration: null,
                    request: null,
                    status: null,
                    user: null,
                  ),
            )
            .request;

    isAdded.value = meRequested.value == null ? false : null;

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
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.avatarUrl),
              radius: 50,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.username,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (user.matualCount != 0)
                    Text(
                      '${user.matualCount} matual friends',
                      style: const TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 5),
                  Obx(() {
                    if (isOther) {
                      return isAdded.value == false
                          ? Row(
                            children: [
                              Expanded(
                                child: MyButton(
                                  label: 'Add friend'.tr,
                                  onPressed: () async {
                                    final added = await userService.addFriend(
                                      user.id,
                                    );
                                    if (added) isAdded.value = true;
                                  },
                                  fontColor: theme.surface,
                                  radius: 10,
                                  isBold: true,
                                  fontSize: 14,
                                  height: 40,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: MyButton(
                                  label: 'Remove'.tr,
                                  onPressed: () async {
                                    // final removed = await userService.removeFriend(user.id);
                                    // isAdded.value = false;
                                  },
                                  type: 2,
                                  color: theme.secondaryContainer,
                                  fontColor: theme.tertiary,
                                  radius: 10,
                                  isBold: true,
                                  fontSize: 14,
                                  height: 40,
                                ),
                              ),
                            ],
                          )
                          : MyButton(
                            label: 'Cancel request'.tr,
                            onPressed: () async {
                              final canceled = await userService.cancelFriend(
                                user.id,
                              );
                              if (canceled) isAdded.value = false;
                            },
                            type: 2,
                            color: theme.secondaryContainer,
                            fontColor: theme.tertiary,
                            radius: 10,
                            isBold: true,
                            fontSize: 14,
                            height: 40,
                          );
                    } else {
                      if (meRequested.value == true) {
                        return isConfirmed.value == null
                            ? Row(
                              children: [
                                Expanded(
                                  child: MyButton(
                                    label: 'Confirm'.tr,
                                    onPressed: () async {
                                      final confirmed = await userService
                                          .acceptFriend(user.id);
                                      if (confirmed) isConfirmed.value = true;
                                    },
                                    fontColor: theme.surface,
                                    radius: 10,
                                    isBold: true,
                                    fontSize: 14,
                                    height: 40,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: MyButton(
                                    label: 'Delete'.tr,
                                    onPressed: () async {
                                      final deleted = await userService
                                          .cancelFriend(user.id);
                                      if (deleted) isConfirmed.value = false;
                                    },
                                    type: 2,
                                    color: theme.secondaryContainer,
                                    fontColor: theme.tertiary,
                                    radius: 10,
                                    isBold: true,
                                    fontSize: 14,
                                    height: 40,
                                  ),
                                ),
                              ],
                            )
                            : Text(
                              isConfirmed.value == true
                                  ? 'You are now friends'.tr
                                  : 'Request removed'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            );
                      } else {
                        return isCanceled.value == false
                            ? MyButton(
                              label: 'Cancel request'.tr,
                              onPressed: () async {
                                final canceled = await userService.cancelFriend(
                                  user.id,
                                );
                                if (canceled) isCanceled.value = true;
                              },
                              type: 2,
                              color: theme.secondaryContainer,
                              fontColor: theme.tertiary,
                              radius: 10,
                              isBold: true,
                              fontSize: 14,
                              height: 40,
                            )
                            : Text(
                              'Request canceled'.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            );
                      }
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
