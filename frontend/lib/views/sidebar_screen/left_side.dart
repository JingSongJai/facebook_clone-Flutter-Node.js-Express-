import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeftSideBar extends StatelessWidget {
  const LeftSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      color: color.surface,
      width: 200,
      padding: const EdgeInsets.all(15),
      child: Obx(
        () => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: IconButton.filledTonal(
                onPressed: () {
                  Get.toNamed(AppPage.profile);
                },
                icon: Row(
                  spacing: 10,
                  children: [
                    AuthService.to.user?.avatarUrl == null
                        ? SizedBox.shrink()
                        : CircleAvatar(
                          backgroundImage: NetworkImage(
                            AuthService.to.user!.avatarUrl,
                          ),
                        ),
                    Text('${AuthService.to.user?.username}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
