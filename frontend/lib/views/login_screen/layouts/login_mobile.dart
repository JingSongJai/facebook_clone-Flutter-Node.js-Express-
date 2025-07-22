import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/utils/utils.dart';
import 'package:facebook_clone/views/login_screen/login_controller.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:facebook_clone/widgets/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileLoginScreen extends GetView<LoginController> {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Get.focusScope!.unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Obx(
                        () => _buildLanguageButton(
                          controller.selectedLanguage.value,
                          context,
                        ),
                      ),
                    ),
                    SliverList.list(
                      children: [
                        const SizedBox(height: 100),
                        Image.asset(
                          'assets/images/png/App Logo.png',
                          width: 70,
                          height: 70,
                        ),
                        const SizedBox(height: 100),
                        Form(
                          key: controller.formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              MyTextField(
                                label: 'Mobile number or email'.tr,
                                controller: controller.usernameController,
                              ),
                              const SizedBox(height: 15),
                              MyTextField(
                                label: 'Password'.tr,
                                controller: controller.passwordController,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        MyButton(
                          label: 'Log in'.tr,
                          onPressed: () async {
                            if (controller.formKey.currentState!.validate()) {
                              Utils.showOverlay(
                                context,
                                CircularProgressIndicator.adaptive(),
                              );
                              await controller.onLogin();
                              Utils.hideOverlay();
                            } else {}
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
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: MyButton(
                    label: 'Create Account'.tr,
                    onPressed: () {
                      Get.toNamed(AppPage.register);
                    },
                    type: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton(String label, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => _buildLanguageBottomSheet(context),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(width: 5),
          Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  Widget _buildLanguageBottomSheet(context) {
    return Container(
      width: double.infinity,
      height: 800,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.close),
          ),
          const SizedBox(height: 10),
          Text(
            'Select your language'.tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: controller.languages.length,
                itemBuilder:
                    (context, index) => Obx(
                      () => CheckboxListTile.adaptive(
                        onChanged: (value) => _onChangeLanguage(value!, index),
                        value:
                            controller.selectedLanguage.value ==
                            controller.languages[index],
                        title: Text(controller.languages[index]),
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onChangeLanguage(bool value, int index) {
    controller.selectedLanguage.value = controller.languages[index];

    switch (controller.selectedLanguage.value) {
      case 'English (US)':
        Get.updateLocale(Locale('en'));
        break;
      case 'ភាសាខ្មែរ':
        Get.updateLocale(Locale('km'));
        break;
    }
  }
}
