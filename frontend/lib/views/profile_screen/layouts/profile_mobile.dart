import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:facebook_clone/models/post_model.dart';
import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/services/post_service.dart';
import 'package:facebook_clone/services/user_service.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:facebook_clone/widgets/my_friend_widget.dart';
import 'package:facebook_clone/widgets/user_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileProfileScreen extends StatefulWidget {
  const MobileProfileScreen({super.key});

  @override
  State<MobileProfileScreen> createState() => _MobileProfileScreenState();
}

class _MobileProfileScreenState extends State<MobileProfileScreen> {
  late ColorScheme color;
  final user = AuthService.to.user.obs;
  final isLoading = false.obs;
  final selectedIndex = 0.obs;
  final posts = <PostModel>[].obs;
  final friends = <UserModel>[].obs;

  final List<String> tabs = ['Post', 'Photos', 'Videos'];
  final options = ['See photo', 'Upload photo', 'Choose cover photo'];
  final bool isAuth = Get.parameters['id'] == null;

  @override
  void initState() {
    print(user.value?.coverUrl);
    getPosts();
    getFriends();
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    color = Theme.of(context).colorScheme;
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        await getPosts();
        await getFriends();
        await getProfile();
      },
      child: Scaffold(
        backgroundColor: color.surface,
        body: Obx(
          () =>
              isLoading.value
                  ? Center(child: CircularProgressIndicator.adaptive())
                  : CustomScrollView(
                    slivers: [
                      if (Get.parameters['id'] != null)
                        SliverAppBar(
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back_ios_rounded),
                            onPressed: () async {
                              Get.parameters.remove('id');
                              Get.back();
                            },
                          ),
                          pinned: true,
                          actions: [
                            IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      SliverToBoxAdapter(child: _buildProfileHeader(context)),
                      SliverToBoxAdapter(
                        child: Container(
                          height: 5,
                          color: color.secondary,
                          padding: const EdgeInsets.all(8),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: color.surface,
                          padding: const EdgeInsets.only(
                            left: 8,
                            right: 8,
                            top: 8,
                          ),
                          child: Wrap(
                            spacing: 10,
                            children: List<Widget>.generate(
                              tabs.length,
                              (index) => _buildCategory(context, index),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                          color: color.surface,
                          child: const Divider(
                            thickness: 0.5,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(child: _buildFriendHeaderSection()),
                      SliverPadding(
                        padding: const EdgeInsets.all(8),
                        sliver: _buildFriendListSection(),
                      ),

                      SliverToBoxAdapter(
                        child:
                            isAuth
                                ? _buildPostSection(context)
                                : (user.value?.friends ?? []).isNotEmpty
                                ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${user.value?.username}\'s posts',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: color.tertiary,
                                    ),
                                  ),
                                )
                                : Container(
                                  height: 50,
                                  color: color.surface,
                                  child: Center(
                                    child: Text(
                                      'No posts available'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: color.tertiary,
                                      ),
                                    ),
                                  ),
                                ),
                      ),

                      // if (Get.parameters['id'] != null &&
                      //     isLoading.value &&
                      //     posts.isEmpty)
                      // SliverToBoxAdapter(
                      //   child: Center(child: CircularProgressIndicator.adaptive()),
                      // ),
                      isLoading.value
                          ? SliverPadding(
                            padding: const EdgeInsets.all(10),
                            sliver: SliverToBoxAdapter(
                              child: Center(
                                child: CircularProgressIndicator.adaptive(),
                              ),
                            ),
                          )
                          : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => UserPost(
                                post: posts[index],
                                isUserPost: true,
                              ),
                              childCount: posts.length,
                            ),
                          ),
                    ],
                  ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(context) {
    return Container(
      height: 386,
      color: color.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      user.value?.coverUrl != null
                          ? InkWell(
                            onTap: () async {
                              showModalBottomSheet(
                                context: context,
                                builder:
                                    (context) => _buildOptionsBottomSheet(),
                              );
                            },
                            child: Image.network(
                              user.value!.coverUrl!,
                              height: 200,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                          : InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder:
                                    (context) => _buildOptionsBottomSheet(),
                              );
                            },
                            child: Container(
                              color: Colors.grey,
                              height: 200,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (isAuth)
                                      Icon(Icons.add_photo_alternate_rounded),
                                    if (isAuth)
                                      Text(
                                        'Add cover photo'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      if (isAuth)
                        Positioned(
                          right: 5,
                          bottom: 5,
                          child: IconButton.filledTonal(
                            icon: Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder:
                                    (context) => _buildOptionsBottomSheet(),
                              );
                            },
                            color: Colors.grey.shade300,
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity(
                              vertical: -1,
                              horizontal: -1,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 50),
                ],
              ),
              Positioned(
                left: 10,
                bottom: 0,
                child: Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => _buildOptionsBottomSheet(true),
                        );
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: color.surface,
                            width: 3,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                          borderRadius: BorderRadius.circular(75),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child:
                            user.value?.avatarUrl != null
                                ? Image.network(
                                  user.value!.avatarUrl,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )
                                : Image.asset('assets/images/png/user.png'),
                      ),
                    ),
                    if (isAuth)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: IconButton.filledTonal(
                          icon: Icon(
                            Icons.camera_alt,
                            size: 20,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder:
                                  (context) => _buildOptionsBottomSheet(true),
                            );
                          },
                          color: Colors.grey.shade300,
                          padding: EdgeInsets.zero,
                          visualDensity: VisualDensity(
                            vertical: -1,
                            horizontal: -1,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.value?.username ?? '',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                if (!isAuth)
                  Row(
                    children: [
                      Text(
                        (user.value?.friends ?? []).length.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' friends', style: TextStyle(color: Colors.grey)),
                      Text(
                        ' • ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        (user.value?.matualCount ?? []).toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' mutual', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                Text(
                  user.value?.bio ?? '',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                ),
                Row(
                  spacing: 7,
                  children: [
                    Expanded(
                      flex: 3,
                      child: MyButton(
                        label: isAuth ? 'Add to Story'.tr : 'Friends'.tr,
                        onPressed: () async {
                          if (!isAuth && user.value != null) {
                            await UserService().removeFriend(user.value!.id);
                          }
                        },
                        radius: 7,
                        isBold: true,
                        icon:
                            isAuth
                                ? Icon(
                                  Icons.add,
                                  color: color.surface,
                                  size: 20,
                                )
                                : Icon(
                                  Icons.person_remove_alt_1,
                                  color: color.tertiary,
                                  size: 20,
                                ),
                        height: 40,
                        fontSize: 14,
                        fontColor: isAuth ? color.surface : color.tertiary,
                        color: isAuth ? color.primary : color.secondary,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: MyButton(
                        label: isAuth ? 'Edit profile'.tr : 'Message'.tr,
                        onPressed: () {},
                        radius: 7,
                        isBold: true,
                        icon:
                            isAuth
                                ? Icon(
                                  Icons.edit,
                                  color: color.tertiary,
                                  size: 20,
                                )
                                : Icon(
                                  Icons.message,
                                  color: color.surface,
                                  size: 20,
                                ),
                        height: 40,
                        fontSize: 14,
                        color: isAuth ? color.secondary : color.primary,
                        type: 0,
                        fontColor: isAuth ? color.tertiary : color.surface,
                      ),
                    ),
                    IconButton.filledTonal(
                      icon: Icon(Icons.more_horiz, size: 18),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7),
                        ),
                        padding: EdgeInsets.all(10),
                        backgroundColor: color.secondary,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => selectedIndex.value = index,
      child: Container(
        height: 38,
        width: 70,
        decoration: BoxDecoration(
          color:
              selectedIndex.value == index
                  ? Colors.blue[50]
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(17),
        ),
        alignment: Alignment.center,
        child: Text(
          tabs[index],
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color:
                selectedIndex.value == index
                    ? color.primary
                    : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildPostSection(context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text('Post'.tr, style: TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text('Filters'.tr, style: TextStyle(color: Colors.blue)),
            ],
          ),
          InkWell(
            onTap: () {
              Get.toNamed(AppPage.post, arguments: user.value);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  user.value?.avatarUrl != null
                      ? CircleAvatar(
                        backgroundImage: NetworkImage(user.value!.avatarUrl),
                        radius: 20,
                      )
                      : Image.asset(
                        'assets/images/png/user.png',
                        width: 40,
                        height: 40,
                      ),
                  const SizedBox(width: 5),
                  Text('What\'s on your mind?'),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.image, color: Colors.green),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFriendHeaderSection() {
    return Container(
      color: color.surface,
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Friends'.tr,
                style: TextStyle(
                  color: color.tertiary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              MyButton(
                onPressed: () {},
                label: 'Find friends'.tr,
                width: 100,
                color: Colors.transparent,
                fontColor: color.primary,
                fontSize: 14,
              ),
            ],
          ),
          Text('${friends.length} friends'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildFriendListSection() {
    return SliverGrid.count(
      crossAxisCount: 3,
      childAspectRatio: 1 / 1.4,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      children: List.generate(friends.length > 6 ? 6 : friends.length, (index) {
        return isLoading.value
            ? Center(child: CircularProgressIndicator.adaptive())
            : MyFriendWidget(user: friends[index]);
      }),
    );
  }

  Widget _buildOptionsBottomSheet([isProfile = false]) {
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
            options
                .map(
                  (sort) => ListTile(
                    title: Text(sort.tr),
                    onTap: () async {
                      switch (sort) {
                        case 'See photo':
                          Get.back();

                          final imageProvider =
                              Image.network(
                                isProfile
                                    ? user.value!.avatarUrl
                                    : user.value!.coverUrl!,
                              ).image;
                          showImageViewer(context, imageProvider);
                          break;
                        case 'Upload photo':
                          break;
                        case 'Choose cover photo':
                          break;
                      }
                    },
                    leading: Icon(Icons.sort),
                  ),
                )
                .toList(),
      ),
    );
  }

  Future<void> getPosts() async {
    isLoading.value = true;
    posts.value = await PostService().getPosts(
      Get.parameters['id'] ?? AuthService.to.user!.id,
    );
    isLoading.value = false;
  }

  Future<void> getFriends() async {
    isLoading.value = true;
    friends.value = await UserService().getUsers(
      friend: true,
      id: Get.parameters['id'] ?? '',
    );
    isLoading.value = false;
  }

  Future<void> getProfile() async {
    isLoading.value = true;
    user.value = await UserService().profile(Get.parameters['id']);
    isLoading.value = false;
  }

  // Future<bool> updateImage([bool isProfile = true]) async {
  //   isLoading.value = true;
  //   final isUpdated = await UserService().updateImage();
  // }
}
