import 'package:facebook_clone/models/story_model.dart';
import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/responsive/resposive.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/views/home_screen/home_controller.dart';
import 'package:facebook_clone/views/menu_screen/menu_screen.dart';
import 'package:facebook_clone/views/sidebar_screen/left_side.dart';
import 'package:facebook_clone/widgets/user_post.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WebHomeScreen extends GetView<HomeController> {
  const WebHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: color.surface,
      body: Obx(
        () => Column(
          children: [
            MenuScreen(),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (Responsive.isWindow(context))
                    Expanded(child: LeftSideBar()),
                  if (Responsive.isWindow(context)) const SizedBox(width: 50),
                  _buildBody(color),
                  if (!Responsive.isMobile(context))
                    Expanded(child: _buildRightSide(color)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRightSide(ColorScheme color) {
    return Container(color: color.surface);
  }

  Widget _buildBody(ColorScheme color) {
    final width = MediaQuery.sizeOf(Get.context!).width;

    return SizedBox(
      width: width <= 550 ? width : 550,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () {
                Get.toNamed(AppPage.post, arguments: AuthService.to.user);
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: kIsWeb ? color.secondary : color.secondary,
                  borderRadius: kIsWeb ? BorderRadius.circular(10) : null,
                ),
                padding: const EdgeInsets.all(8.0),
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 8.0,
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    AuthService.to.user?.avatarUrl == null
                        ? SizedBox.shrink()
                        : CircleAvatar(
                          backgroundImage: NetworkImage(
                            AuthService.to.user!.avatarUrl,
                          ),
                        ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: color.secondary),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'What\'s on your mind?'.tr,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(bottom: 2.0),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildAddStory(color),
                  ...controller.stories.map((story) {
                    return _buildStory(story, color);
                  }),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => GestureDetector(
                onTap: () {
                  Get.toNamed(
                    '/post/${controller.posts[index].id}',
                    arguments: controller.posts[index],
                  );
                },
                child: UserPost(post: controller.posts[index]),
              ),
              childCount: controller.posts.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddStory(ColorScheme color) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppPage.post, arguments: AuthService.to.user);
      },
      child: Container(
        width: 120,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child:
                  AuthService.to.user?.avatarUrl == null
                      ? SizedBox.shrink()
                      : Image.network(
                        AuthService.to.user!.avatarUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
            ),
            Expanded(
              child: Container(
                clipBehavior: Clip.none,
                color: color.secondary,
                padding: const EdgeInsets.all(3.0),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Create story'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color.tertiary,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color.secondary,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.add_circle,
                          size: 40,
                          color: color.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStory(StoryModel story, ColorScheme color) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      width: 120,
      margin: const EdgeInsets.only(left: kIsWeb ? 10 : 5),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            story.imageUrl,
            fit: BoxFit.cover,
            height: double.infinity,
          ),
          Positioned(
            top: 10,
            left: 10,
            child:
                AuthService.to.user?.avatarUrl == null
                    ? SizedBox.shrink()
                    : CircleAvatar(
                      backgroundImage: NetworkImage(story.user.avatarUrl),
                      radius: 15,
                    ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: Text(
              story.user.username,
              style: TextStyle(color: color.tertiary),
            ),
          ),
        ],
      ),
    );
  }
}
