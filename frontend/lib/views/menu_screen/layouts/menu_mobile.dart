import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/views/menu_screen/menu_controller.dart' as menu;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MobileMenuScreen extends GetView<menu.MenuScreenController> {
  const MobileMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: color.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: SvgPicture.network(
              'https://static.xx.fbcdn.net/rsrc.php/y1/r/4lCu2zih0ca.svg',
              width: 150,
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add_circle, size: 27, color: color.tertiary),
                onPressed: () {
                  Get.find<AuthService>().logout();
                },
              ),
              IconButton(
                icon: Icon(Icons.search, size: 27, color: color.tertiary),
                onPressed: () async {
                  // Get.find<HomeController>().counter.value++;
                  // log('Counter: ${Get.find<HomeController>().counter.value}');
                },
              ),
              IconButton(
                icon: Icon(Icons.messenger, size: 27, color: color.tertiary),
                onPressed: () async {},
              ),
            ],
            toolbarHeight: 40,
          ),
          SliverFloatingHeader(
            snapMode: FloatingHeaderSnapMode.scroll,
            child: Obx(
              () => TabBar(
                controller: controller.tabController,
                tabs: List.generate(6, (index) => controller.getIcon(index)),
                dividerHeight: 0.5,
                dividerColor: Colors.grey,
                splashBorderRadius: BorderRadius.circular(0),
                splashFactory: NoSplash.splashFactory,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 2,
                labelPadding: const EdgeInsets.all(5),
                onTap: (index) async {
                  controller.selectedIndex.value = index;
                },
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: controller.tabController,
              children: controller.views,
            ),
          ),
        ],
      ),
    );
  }
}
