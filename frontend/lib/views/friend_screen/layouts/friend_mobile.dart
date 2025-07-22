import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/services/online_service.dart';
import 'package:facebook_clone/views/friend_screen/friend_controller.dart';
import 'package:facebook_clone/widgets/friend_request.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileFriendScreen extends GetView<FriendController> {
  MobileFriendScreen({super.key});
  late TextTheme textTheme;
  late ColorScheme colorTheme;
  final onlineService = Get.find<OnlineService>();

  @override
  Widget build(BuildContext context) {
    textTheme = Theme.of(context).textTheme;
    colorTheme = Theme.of(context).colorScheme;

    return RefreshIndicator(
      onRefresh: () async {
        await controller.getUsers();
      },
      child: Scaffold(
        body: Obx(
          () => CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Text('Friends'.tr, style: textTheme.titleMedium),
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (onlineService.ids.isNotEmpty)
                              MyButton(
                                icon: Icon(
                                  Icons.circle,
                                  color: Colors.green.shade400,
                                  size: 15,
                                ),
                                label: '${onlineService.ids.length} online'.tr,
                                onPressed: () {
                                  Get.toNamed(
                                    AppPage.viewFriend,
                                    parameters: {'type': 'online_friend'},
                                  );
                                },
                                width: 130,
                                color: colorTheme.secondaryContainer,
                                fontColor: colorTheme.tertiary,
                                isBold: true,
                                fontSize: 14,
                                height: 40,
                              ),
                            const SizedBox(width: 10),
                            MyButton(
                              label: 'Friend requests'.tr,
                              onPressed: () {
                                Get.toNamed(
                                  AppPage.viewFriend,
                                  parameters: {'type': 'request_friend'},
                                );
                              },
                              width: 150,
                              color: colorTheme.secondaryContainer,
                              fontColor: colorTheme.tertiary,
                              isBold: true,
                              fontSize: 14,
                              height: 40,
                            ),
                            const SizedBox(width: 10),
                            MyButton(
                              label: 'Your friends'.tr,
                              onPressed: () {
                                Get.toNamed(
                                  AppPage.viewFriend,
                                  parameters: {'type': 'your_friend'},
                                );
                              },
                              width: 120,
                              color: colorTheme.secondaryContainer,
                              fontColor: colorTheme.tertiary,
                              isBold: true,
                              fontSize: 14,
                              height: 40,
                            ),
                          ],
                        ),
                      ),
                      if (controller.requests.isNotEmpty)
                        Divider(
                          color: colorTheme.secondaryContainer,
                          thickness: 0.7,
                          height: 3,
                        ),
                    ],
                  ),
                ),
              ),

              if (controller.requests.isNotEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 10,
                      children: [
                        Text(
                          'Friend requests'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          controller.requests.length.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                          ),
                        ),
                        const Spacer(),
                        MyButton(
                          label: 'See all'.tr,
                          onPressed: () {
                            Get.toNamed(
                              AppPage.viewFriend,
                              parameters: {'type': 'request_friend'},
                            );
                          },
                          color: Colors.transparent,
                          fontColor: Colors.blue,
                          width: 50,
                          fontSize: 14,
                          radius: 5,
                        ),
                      ],
                    ),
                  ),
                ),
              if (controller.requests.isNotEmpty)
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return FriendRequestWidget(
                      user: controller.requests[index],
                      isOther: false,
                    );
                  }, childCount: controller.requests.length),
                ),

              SliverToBoxAdapter(
                child: Divider(
                  color: colorTheme.secondaryContainer,
                  thickness: 0.7,
                  indent: 8,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'People you may know'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return FriendRequestWidget(user: controller.friends[index]);
                }, childCount: controller.friends.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
