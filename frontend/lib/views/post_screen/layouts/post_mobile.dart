import 'package:facebook_clone/services/api_client.dart';
import 'package:facebook_clone/views/post_screen/post_controller.dart';
import 'package:facebook_clone/widgets/image_grid.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobilePostScreen extends GetView<PostController> {
  const MobilePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () {
            ApiClient.cancelToken.cancel('Post cancel!');
            Get.back();
          },
        ),
        titleSpacing: 0,
        title: Text('Create post'.tr, style: TextStyle(fontSize: 18)),
        actions: [
          MyButton(
            onPressed: () async {
              await controller.createPost();
            },
            label: 'POST'.tr,
            width: 50,
            radius: 10,
            fontSize: 14,
            isBold: true,
            height: 40,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              _buildHeader(),
              Obx(
                () => TextField(
                  controller: controller.textController,
                  decoration: InputDecoration(
                    hintText:
                        controller.files.isEmpty
                            ? 'What\'s on your mind?'.tr
                            : 'Write about your photo/video'.tr,
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  style: TextStyle(
                    fontSize: controller.files.isEmpty ? 20 : 14,
                  ),
                  maxLines: controller.files.isEmpty ? 5 : null,
                  focusNode: controller.focusNode,
                ),
              ),
              _buildDisplayImages(context),
            ],
          ),
          Positioned(
            left: 0,
            bottom: 0,
            right: 0,
            child: Obx(
              () =>
                  controller.isShowButton.value && controller.files.isEmpty
                      ? Column(
                        children:
                            controller.listButton
                                .map(
                                  (button) => ListTile(
                                    leading: button[0] as Icon,
                                    title: Text(
                                      button[1] as String,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    minVerticalPadding: 1,
                                    dense: true,
                                    onTap: () async {
                                      if (button[1] == 'Photo/video') {
                                        if (!controller.isChoosing.value) {
                                          await controller.pickImage();
                                        }
                                      }
                                    },
                                  ),
                                )
                                .toList(),
                      )
                      : Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade500,
                            width: 0.7,
                          ),
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Row(
                          children: List.generate(5, (index) {
                            if (index == 4) {
                              return Expanded(
                                child: ListTile(
                                  onTap: () {
                                    controller.focusNode.enclosingScope!
                                        .unfocus();
                                    controller.isShowButton.value = true;
                                  },
                                  leading: Icon(Icons.more_horiz_rounded),
                                ),
                              );
                            }
                            return Expanded(
                              child: ListTile(
                                leading:
                                    controller.listButton[index][0] as Icon,
                                onTap: () async {
                                  if (index == 0) {
                                    await controller.pickImage();
                                  }
                                },
                              ),
                            );
                          }),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(controller.user.avatarUrl),
          ),
          const SizedBox(width: 10),
          Text(
            controller.user.username,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildDisplayImages(context) {
    return Obx(
      () => Visibility(
        visible: controller.files.isNotEmpty,
        child: ImageGrid(
          images: controller.files.map((file) => file.path).toList(),
          isFile: true,
        ),
      ),
    );
  }
}
