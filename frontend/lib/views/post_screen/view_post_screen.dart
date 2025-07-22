import 'package:facebook_clone/models/post_model.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/services/post_service.dart';
import 'package:facebook_clone/utils/utils.dart';
import 'package:facebook_clone/widgets/comment_widget.dart';
import 'package:facebook_clone/widgets/user_react.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ViewPostScreen extends StatefulWidget {
  const ViewPostScreen({super.key});

  @override
  State<ViewPostScreen> createState() => _ViewPostScreenState();
}

class _ViewPostScreenState extends State<ViewPostScreen> {
  String id = AuthService.to.user!.id;
  final isLiked = false.obs;
  final y = 0.0.obs;
  final reactTypes = ['Like', 'Love', 'Care', 'Laugh', 'Wow', 'Sad', 'Angry'];
  final selectedReact = 'Like'.obs;
  final isProcessing = false.obs;
  Rx<int> selectedCategory = Rx(1);
  late ColorScheme theme;
  final icons = const [
    Icon(Icons.camera_alt_outlined, size: 30),
    Icon(Icons.gif_outlined),
    Icon(Icons.tag_faces_outlined),
    Icon(Icons.person_outline),
    Icon(Icons.star_outline),
  ];
  late Rx<PostModel> post = Rx<PostModel>(Get.arguments as PostModel);
  final textController = TextEditingController();

  @override
  void initState() {
    isLiked.value = post.value.likes.any((like) => like.user.id == id);
    selectedReact.value =
        isLiked.value
            ? post.value.likes
                .singleWhere((like) => like.user.id == id)
                .reactType
            : 'Like';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildProfileHeader()),
          SliverToBoxAdapter(child: _buildPostInfo()),
          SliverToBoxAdapter(child: _buildPostAction()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Column(
                children: [
                  Image.network(post.value.imageUrls[index]),
                  _buildPostInfo(),
                  _buildPostAction(),
                  Container(height: 5, color: theme.secondary),
                ],
              ),
              childCount: post.value.imageUrls.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(post.value.user.avatarUrl),
            radius: 24,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.value.user.username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              const SizedBox(height: 5),
              Text(
                Utils.durationAgo(post.value.createdAt, DateTime.now()),
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostInfo() {
    return InkWell(
      onTap: () async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide.none,
          ),
          backgroundColor: theme.surface,
          builder: (context) => _buildCommentBottomSheet(context),
        );
        selectedCategory.value = 1;
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Obx(
          () => Row(
            children: [
              Visibility(
                visible: post.value.likes.isNotEmpty,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Utils.getReactions(post.value.likes),
                    Text(
                      '${post.value.likes.length}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Visibility(
                visible: post.value.comments.isNotEmpty,
                child: Text(
                  '${post.value.comments.length} comments',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(width: 10),
              Text('11 shares', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostAction() {
    final OverlayPortalController controller = OverlayPortalController();

    return OverlayPortal(
      controller: controller,
      overlayChildBuilder:
          (context) => Stack(
            children: [
              GestureDetector(
                onHorizontalDragDown: (details) {
                  controller.hide();
                },
                child: Container(color: Colors.transparent),
              ),
              Obx(
                () => Positioned(
                  left: 10,
                  top: y.value,
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: theme.surface,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 1,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(7),
                    child: Row(
                      spacing: 5,
                      children:
                          reactTypes
                              .map(
                                (react) => GestureDetector(
                                  child: Image.asset(
                                    'assets/images/gif/${react.toLowerCase()}.gif',
                                    width: 40,
                                    height: 40,
                                  ),
                                  onTap: () {
                                    controller.hide();
                                    selectedReact.value = react;
                                    isLiked.value = true;
                                    _likeHandler();
                                  },
                                ),
                              )
                              .toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Obx(
            () => _buildActionButton(
              'Like',
              Image.asset(
                'assets/icons/${isLiked.value ? '${selectedReact.value}-active' : 'like'}.png',
                width: 35,
                height: 35,
              ),
              onTap:
                  isProcessing.value
                      ? null
                      : () {
                        isLiked.value = !isLiked.value;
                        selectedReact.value = 'Like';
                        _likeHandler();
                      },
              onLongPress: () {
                controller.show();
              },
              onTapDown: (details) {
                y.value = details.globalPosition.dy - 80;
              },
            ),
          ),
          _buildActionButton(
            'comment',
            SvgPicture.asset('assets/icons/comment.svg', width: 24),
            onTap: () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                shape: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: BorderSide.none,
                ),
                backgroundColor: theme.surface,
                builder: (context) => _buildCommentBottomSheet(context),
              );

              selectedCategory.value = 1;
            },
          ),
          _buildActionButton(
            'Send',
            SvgPicture.asset('assets/icons/messenger.svg'),
          ),
          _buildActionButton(
            'Share',
            SvgPicture.asset('assets/icons/share.svg', width: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentBottomSheet(context) {
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 1,
      minChildSize: 1,
      builder:
          (context, scrollController) => Obx(
            () => Stack(
              children: [
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          _buildCategoryCard(
                            Row(
                              children: [
                                Utils.getReactions(post.value.likes),
                                Text(
                                  post.value.likes.length.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                  ),
                                ),
                              ],
                            ),
                            0,
                          ),
                          const SizedBox(width: 20),
                          _buildCategoryCard(
                            Text(
                              '${post.value.comments.length} comments',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: theme.tertiary,
                              ),
                            ),
                            1,
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: AnimatedPadding(
                        duration: const Duration(milliseconds: 100),
                        padding: EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 8,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                        ),
                        child:
                            selectedCategory.value == 0
                                ? ListView.separated(
                                  controller: scrollController,
                                  itemCount: post.value.likes.length,
                                  itemBuilder:
                                      (context, index) => UserReactWidget(
                                        like: post.value.likes[index],
                                      ),
                                  separatorBuilder:
                                      (context, index) =>
                                          const SizedBox(height: 5),
                                )
                                : ListView.separated(
                                  controller: scrollController,
                                  itemCount: post.value.comments.length,
                                  itemBuilder:
                                      (context, index) => CommentWidget(
                                        comment: post.value.comments[index],
                                      ),
                                  separatorBuilder:
                                      (context, index) =>
                                          const SizedBox(height: 5),
                                ),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 100),
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      color: theme.surface,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 10,
                    ),
                    child: Column(
                      spacing: 7,
                      children: [
                        TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            hintText:
                                'Comment as ${Get.find<AuthService>().user?.username}'
                                    .tr,
                            hintStyle: TextStyle(
                              color: Color(0xFFA3A3A3),
                              fontSize: 16,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: theme.secondary,
                            contentPadding: const EdgeInsets.all(10),
                          ),
                        ),
                        if (MediaQuery.of(context).viewInsets.bottom >= 50)
                          Row(
                            spacing: 20,
                            children: [
                              ...icons.map(
                                (icon) => GestureDetector(
                                  onTap: () {
                                    if (icon ==
                                        Icon(Icons.camera_alt_outlined)) {}
                                  },
                                  child: Center(child: icon),
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: Icon(Icons.send_outlined),
                                onPressed: () async {
                                  if (textController.text.isNotEmpty) {
                                    final updatedPost = await PostService()
                                        .addComment(
                                          textController.text,
                                          post.value.id,
                                        );

                                    if (updatedPost != null) {
                                      textController.text = '';
                                      Get.focusScope!.unfocus();
                                      post.value = updatedPost;
                                    }
                                  }
                                },
                              ),
                            ],
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

  Widget _buildCategoryCard(Widget child, int index) {
    return GestureDetector(
      onTap: () {
        selectedCategory.value = index;
      },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color:
              selectedCategory.value == index
                  ? Colors.blue[50]
                  : Colors.transparent,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildActionButton(
    String text,
    Widget icon, {
    Function()? onTap,
    Function()? onLongPress,
    Function(TapDownDetails)? onTapDown,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      onTapDown: onTapDown,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 5),
            Text(text, style: TextStyle(color: Colors.black, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _likeHandler() async {
    if (isProcessing.value) return;

    final postService = PostService();

    isProcessing.value = true;

    if (!isLiked.value) {
      final updatedPost = await postService.unLikePost(
        selectedReact.value,
        post.value.id,
      );
      if (updatedPost != null) post.value = updatedPost;
    } else {
      final updatedPost = await postService.likePost(
        selectedReact.value,
        post.value.id,
      );
      if (updatedPost != null) post.value = updatedPost;
    }

    isProcessing.value = false;
  }
}
