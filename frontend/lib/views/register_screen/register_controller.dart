import 'package:facebook_clone/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

class RegisterController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final picker = ImagePicker();
  final RxnString profileImagePath = RxnString(null);
  XFile? file;

  Future<void> onRegister() async {
    Uint8List? avatar;

    if (profileImagePath.value == null) {
      ByteData byteData = await rootBundle.load('assets/images/png/user.png');
      avatar = byteData.buffer.asUint8List();
    }

    var data = {
      'username': usernameController.text,
      'password': passwordController.text,
      'image':
          profileImagePath.value != null
              ? await dio.MultipartFile.fromFile(
                profileImagePath.value!,
                filename: file!.name,
              )
              : dio.MultipartFile.fromBytes(avatar!, filename: 'user.png'),
    };

    await UserService().register(data);
  }

  Future<void> pickProfileImage(bool isCamera) async {
    file = await picker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );

    if (file != null) {
      profileImagePath.value = file!.path;
    }
  }
}
