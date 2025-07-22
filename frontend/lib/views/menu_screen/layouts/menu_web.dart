import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/responsive/resposive.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:facebook_clone/views/menu_screen/menu_controller.dart' as menu;

class WebMenuScreen extends GetView<menu.MenuScreenController> {
  const WebMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Stack(
      children: [
        AppBar(
          backgroundColor: color.secondary,
          surfaceTintColor: color.secondary,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => Get.offAllNamed(AppPage.home),
              child: Image.asset('assets/images/png/icon.png', width: 40),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton.filledTonal(
              icon: Icon(Icons.menu, size: 22, color: color.tertiary),
              onPressed: () {
                Get.find<AuthService>().logout();
              },
            ),
            const SizedBox(width: 10),
            IconButton.filledTonal(
              icon: Icon(Icons.message, size: 22, color: color.tertiary),
              onPressed: () {},
            ),
            const SizedBox(width: 10),
            IconButton.filledTonal(
              icon: Icon(Icons.notifications, size: 22, color: color.tertiary),
              onPressed: () {},
            ),
            const SizedBox(width: 10),
            IconButton(
              icon:
                  AuthService.to.user?.avatarUrl == null
                      ? CircularProgressIndicator.adaptive()
                      : CircleAvatar(
                        backgroundImage: NetworkImage(
                          AuthService.to.user!.avatarUrl,
                        ),
                      ),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 10),
          ],
        ),
        Responsive.isMobile(context)
            ? SizedBox.shrink()
            : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  List.generate(
                    controller.webTabs.length,
                    (index) =>
                        _buildTabBar(controller.webTabs[index], color, index),
                  ).toList(),
            ),
      ],
    );
  }

  Widget _buildTabBar(IconData icon, ColorScheme color, int index) {
    return InkWell(
      onTap: () {
        controller.selectedIndex.value = index;
      },
      borderRadius: BorderRadius.circular(10),
      splashColor: color.surface,
      hoverColor: color.secondaryContainer,
      child: Obx(
        () => AnimatedContainer(
          width: 70,
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            border:
                controller.selectedIndex.value == index
                    ? Border(bottom: BorderSide(width: 4, color: color.primary))
                    : null,
          ),
          child: Center(
            child: Icon(
              icon,
              color:
                  controller.selectedIndex.value == index
                      ? color.primary
                      : color.tertiary,
            ),
          ),
        ),
      ),
    );
  }
}
