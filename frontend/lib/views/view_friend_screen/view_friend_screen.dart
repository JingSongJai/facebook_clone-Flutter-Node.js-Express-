import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/services/online_service.dart';
import 'package:facebook_clone/views/view_friend_screen/view_friend_controller.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ViewFriendScreen extends GetView<ViewFriendController> {
  const ViewFriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => Get.focusScope!.unfocus(),
      child: Scaffold(
        body: Obx(
          () => CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
                  onPressed: () {
                    Get.back();
                  },
                ),
                title: Text(controller.title, style: TextStyle(fontSize: 18)),
                bottom: PreferredSize(
                  preferredSize: Size(double.infinity, 50),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: controller.textController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: color.secondary,
                        hintText: 'Search firends'.tr,
                        prefixIcon: Icon(Icons.search, color: color.tertiary),
                        isDense: true,
                      ),
                      onChanged: (value) => controller.text.value = value,
                    ),
                  ),
                ),
                titleSpacing: 0,
                pinned: true,
              ),
              SliverToBoxAdapter(child: Divider(color: color.secondary)),
              controller.isLoading.value
                  ? SliverToBoxAdapter(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade300,
                      child: _buildLoadingShimmer(color),
                    ),
                  )
                  : SliverPadding(
                    padding: const EdgeInsets.all(8.0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${controller.friends.length} friends',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              MyButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder:
                                        (context) =>
                                            _buildSortBottomSheet(color),
                                  );
                                },
                                label: 'Sort',
                                fontColor: color.primary,
                                width: 50,
                                fontSize: 15,
                                color: color.surface,
                                height: 30,
                              ),
                            ],
                          ),
                          if (controller.title == 'Online friends')
                            Text(
                              '${controller.friends.length} online',
                              style: TextStyle(fontSize: 14),
                            ),
                        ],
                      ),
                    ),
                  ),
              controller.isLoading.value
                  ? _buildLoadingListShimmer(color)
                  : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildFriendWidget(controller.friends[index], color),
                      childCount: controller.friends.length,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFriendWidget(UserModel user, ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 10,
        children: [
          Obx(
            () => Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(user.avatarUrl),
                  radius: 30,
                ),
                if (Get.find<OnlineService>().ids.contains(user.id))
                  Icon(Icons.circle, color: Colors.green.shade700, size: 20),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('11 mutual friends'),
              ],
            ),
          ),
          MyButton(
            onPressed: () {},
            icon: Icon(Icons.message, size: 18),
            radius: 10,
            color: color.secondary,
            width: 45,
            height: 40,
          ),
          MyButton(
            onPressed: () {},
            icon: Icon(Icons.more_horiz_rounded, size: 25),
            radius: 10,
            color: color.surface,
            width: 45,
            height: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingShimmer(ColorScheme color) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildShimmer(100, 10, color),
              const Spacer(),
              _buildShimmer(30, 10, color),
            ],
          ),
          _buildShimmer(70, 10, color),
        ],
      ),
    );
  }

  Widget _buildLoadingListShimmer(ColorScheme color) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              spacing: 10,
              children: [
                _buildShimmer(60, 60, color),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    _buildShimmer(100, 10, color),
                    _buildShimmer(200, 10, color),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmer(double width, double height, ColorScheme color) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color.secondary,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  Widget _buildSortBottomSheet(ColorScheme color) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: color.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children:
            controller.sorts
                .map(
                  (sort) => ListTile(
                    title: Text(sort.tr),
                    onTap: () async {
                      switch (sort) {
                        case 'Default':
                          controller.sort = null;
                          await controller.getFriends();
                          break;
                        case 'Newest friend first':
                          controller.sort = 1;
                          await controller.getFriends();
                          break;
                        case 'Oldest friend first':
                          controller.sort = -1;
                          await controller.getFriends();
                          break;
                      }
                      Get.back();
                    },
                    leading: Icon(Icons.sort),
                  ),
                )
                .toList(),
      ),
    );
  }
}
