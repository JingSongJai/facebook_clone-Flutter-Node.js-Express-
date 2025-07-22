import 'dart:io';

import 'package:facebook_clone/utils/utils.dart';
import 'package:facebook_clone/views/register_screen/register_controller.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:facebook_clone/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileRegisterScreen extends GetView<RegisterController> {
  const MobileRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _buildRegisterForm(context),
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            SliverList.list(
              children: [
                const SizedBox(height: 40),
                Image.asset(
                  'assets/images/png/App Logo.png',
                  width: 70,
                  height: 70,
                ),
                const SizedBox(height: 40),
                _buildProfileImagePicker(context),
                const SizedBox(height: 20),
                MyTextField(
                  label: 'Mobile number or email'.tr,
                  controller: controller.usernameController,
                ),
                const SizedBox(height: 15),
                MyTextField(
                  label: 'Password'.tr,
                  controller: controller.passwordController,
                ),
                const SizedBox(height: 15),
                MyButton(
                  label: 'Log in'.tr,
                  onPressed: () async {
                    Utils.showOverlay(
                      context,
                      CircularProgressIndicator.adaptive(),
                    );
                    await controller.onRegister();
                    Utils.hideOverlay();
                  },
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () {},
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Forget password?'.tr),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileImagePicker(BuildContext context) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        clipBehavior: Clip.hardEdge,
        child: GridTile(
          footer: GestureDetector(
            onTap: () async {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return _buildChooseImageChoice();
                },
              );
            },
            child: Container(
              color: Colors.black38,
              width: double.infinity,
              height: 40,
              child: Center(child: Icon(Icons.camera_alt, color: Colors.white)),
            ),
          ),
          child: Obx(
            () =>
                controller.profileImagePath.value != null
                    ? Image.file(
                      File(controller.profileImagePath.value!),
                      fit: BoxFit.cover,
                    )
                    : Image.asset(
                      'assets/images/png/user.png',
                      fit: BoxFit.cover,
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildChooseImageChoice() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text('Camera'.tr),
            onTap: () {
              controller.pickProfileImage(true);
              Get.back();
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: Text('Gallery'.tr),
            onTap: () {
              controller.pickProfileImage(false);
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
