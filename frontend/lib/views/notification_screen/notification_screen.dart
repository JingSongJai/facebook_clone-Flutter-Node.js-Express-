import 'package:facebook_clone/views/notification_screen/notification_controller.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:facebook_clone/widgets/notfication_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: GetBuilder(
        init: NotificationController(),
        builder:
            (controller) => RefreshIndicator(
              onRefresh: () async {
                await controller.getNotifications();
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Notifications'.tr,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              MyButton(
                                onPressed: () {},
                                icon: Icon(Icons.search, size: 30),
                                width: 40,
                                color: color.surface,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => NotificationWidget(
                        notify: controller.notifications[index],
                      ),
                      childCount: controller.notifications.length,
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
