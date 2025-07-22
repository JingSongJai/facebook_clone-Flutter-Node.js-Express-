import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/services/post_service.dart';
import 'package:facebook_clone/views/profile_screen/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as http;

class PostController extends GetxController {
  final UserModel user = Get.arguments as UserModel;
  final listButton = [
    [Icon(Icons.image, color: Colors.green), 'Photo/video'],
    [Icon(Icons.people, color: Colors.deepPurpleAccent), 'Tag people'],
    [Icon(Icons.tag_faces, color: Colors.yellow), 'Feeling/activity'],
    [Icon(Icons.location_pin, color: Colors.deepOrange), 'Check in'],
    [Icon(Icons.video_call, color: Colors.red), 'Live video'],
    [Icon(Icons.abc_rounded, color: Colors.cyan), 'Background color'],
    [Icon(Icons.camera_alt, color: Colors.deepPurpleAccent), 'Camera'],
    [Icon(Icons.gif_rounded, color: Colors.cyanAccent), 'GIF'],
    [Icon(Icons.event, color: Colors.deepPurpleAccent), 'Life event'],
  ];

  final isShowButton = true.obs;
  final files = <XFile>[].obs;
  final isChoosing = false.obs;

  final FocusNode focusNode = FocusNode();
  final textController = TextEditingController();
  final picker = ImagePicker();

  Future<void> pickImage() async {
    isChoosing.value = true;
    var images = await picker.pickMultiImage();
    isChoosing.value = false;
    files.addAll(images);
  }

  Future<void> createPost() async {
    if (textController.text.isEmpty) return;

    var data = {
      'text': textController.text,
      'images':
          files
              .map(
                (file) => http.MultipartFile.fromFileSync(
                  file.path,
                  filename: file.name,
                ),
              )
              .toList(),
    };

    await PostService().createPost(data);
    await Get.find<ProfileController>().getPosts();
    Get.back();
  }

  @override
  void onInit() {
    focusNode.addListener(() {
      if (focusNode.enclosingScope!.isFirstFocus) {
        isShowButton.value = false;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.dispose();
    super.onClose();
  }
}
