import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/theme/dark.dart';
import 'package:facebook_clone/theme/light.dart';
import 'package:facebook_clone/views/setting_screen/setting_controller.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileSettingScreen extends GetView<SettingController> {
  const MobileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Container(
      color: color.secondaryContainer,
      padding: const EdgeInsets.all(8.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Row(
              children: [
                Text(
                  'Menu'.tr,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color.tertiary,
                  ),
                ),
                const Spacer(),
                MyButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings, size: 30, color: color.tertiary),
                  width: 50,
                  color: color.surface,
                ),
                MyButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.search_rounded,
                    size: 30,
                    color: color.tertiary,
                  ),
                  width: 50,
                  color: color.surface,
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      AuthService.to.user!.avatarUrl,
                    ),
                    radius: 25,
                  ),
                  Text(
                    AuthService.to.user!.username.toString(),
                    style: TextStyle(color: color.tertiary, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Your shortcuts'.tr,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverGrid.count(
            crossAxisCount: 2,
            childAspectRatio: 1 / 0.45,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            children:
                controller.shortcuts
                    .map(
                      (shortcut) => _buildShortcut(
                        color,
                        shortcut['label'] as String,
                        shortcut['icon'] as Icon,
                      ),
                    )
                    .toList(),
          ),
          SliverList.list(
            children: [
              const SizedBox(height: 5),
              Obx(
                () => SwitchListTile.adaptive(
                  value: controller.darkMode.value,
                  title: Text('Dark Mode'),
                  onChanged:
                      (value) =>
                          controller.darkMode.value =
                              !controller.darkMode.value,
                ),
              ),
              const SizedBox(height: 5),
              MyButton(
                label: 'Dark Mode',
                onPressed: () {
                  Get.changeTheme(Get.isDarkMode ? light : dark);
                },
                color: color.secondary,
                fontColor: color.tertiary,
                radius: 10,
              ),
              const SizedBox(height: 5),
              MyButton(
                label: 'Dark Mode',
                onPressed: () {
                  Get.changeTheme(Get.isDarkMode ? light : dark);
                },
                color: color.secondary,
                fontColor: color.tertiary,
                radius: 10,
              ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortcut(ColorScheme color, String label, Icon icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [icon, Text(label)],
      ),
    );
  }
}
