import 'package:facebook_clone/responsive/resposive.dart';
import 'package:facebook_clone/views/login_screen/login_controller.dart';
import 'package:facebook_clone/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class WebLoginScreen extends GetView<LoginController> {
  const WebLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Color(0xFFf2f4f7),
      body: FractionallySizedBox(
        widthFactor: Responsive.isWindow(context) ? 0.85 : 0.9,
        child: Column(
          children: [
            const SizedBox(height: 150),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogoSection(context, color),
                _buildLoginSection(color),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context, ColorScheme color) {
    return Expanded(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.network(
              'https://static.xx.fbcdn.net/rsrc.php/y1/r/4lCu2zih0ca.svg',
              width: 200,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 18),
              child: Text(
                'Recent Logins'.tr,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: color.secondary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 3.0, left: 20),
              child: Text(
                'Click your picture or add an account.'.tr,
                style: TextStyle(color: color.secondary),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20),
              child: _buildAddAccount(context, color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAccount(context, ColorScheme color) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _buildLoginDialog(context, color),
        );
      },
      child: MouseRegion(
        cursor: MouseCursor.defer,
        onEnter: (_) {
          controller.blurRadius.value = 20;
        },
        onExit: (_) {
          controller.blurRadius.value = 0;
        },
        child: Obx(
          () => AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 160,
            height: 190,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Color(0xFFf2f4f7),
              border: Border.all(color: Colors.grey.shade300, width: 0.8),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: controller.blurRadius.value,
                ),
              ],
            ),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Icon(
                      Icons.add_circle_rounded,
                      color: Color(0xFF0866ff),
                      size: 50,
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  color: Colors.white,
                  child: Center(
                    child: Text(
                      'Add Account',
                      style: TextStyle(fontSize: 18, color: Color(0xFF0866ff)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginSection(ColorScheme color) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 400,
          height: 350,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.grey.shade300,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              TextFormField(
                controller: controller.usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFA3A3A3),
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFA3A3A3),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0866ff),
                      width: 0.8,
                    ),
                  ),
                  hintText: 'Email or phone number'.tr,
                  hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
                ),
                style: TextStyle(color: color.secondary),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFA3A3A3),
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFA3A3A3),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0866ff),
                      width: 0.8,
                    ),
                  ),
                  hintText: 'Password'.tr,
                  hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
                ),
                style: TextStyle(color: color.secondary),
              ),
              const SizedBox(height: 15),
              MyButton(
                label: 'Log In',
                onPressed: controller.onLogin,
                radius: 7,
                height: 40,
                fontSize: 16,
                isBold: true,
                fontColor: color.tertiary,
                color: color.primary,
              ),
              const SizedBox(height: 15),
              Text(
                'Forget password?'.tr,
                style: TextStyle(color: Color(0xFF0866ff)),
              ),
              Divider(color: Colors.grey.shade300, height: 40),
              MyButton(
                label: 'Create new account',
                onPressed: () {},
                radius: 7,
                height: 40,
                fontSize: 16,
                isBold: true,
                color: Color(0xFF36a420),
                fontColor: color.tertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginDialog(context, ColorScheme color) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SizedBox(
          width: 350,
          height: 330,
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Text(
                    'Log Into Facebook'.tr,
                    style: TextStyle(fontSize: 22, color: color.secondary),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Divider(color: Colors.grey.shade300, height: 40, thickness: 0.5),
              TextFormField(
                controller: controller.usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFA3A3A3),
                      width: 0.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFA3A3A3),
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0866ff),
                      width: 0.8,
                    ),
                  ),
                  hintText: 'Email or phone number'.tr,
                  hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
                ),
              ),
              const SizedBox(height: 15),
              Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFA3A3A3),
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFA3A3A3),
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0866ff),
                        width: 0.8,
                      ),
                    ),
                    hintText: 'Password'.tr,
                    hintStyle: TextStyle(color: Color(0xFFA3A3A3)),
                    suffixIcon: IconButton(
                      icon:
                          controller.hidePassword.value
                              ? Icon(Icons.visibility, size: 20)
                              : Icon(Icons.visibility_off, size: 20),
                      onPressed: () {
                        controller.hidePassword.value =
                            !controller.hidePassword.value;
                      },
                    ),
                  ),
                  obscureText: controller.hidePassword.value,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Obx(
                    () => Checkbox.adaptive(
                      onChanged: (value) {
                        controller.rememberMe.value =
                            !controller.rememberMe.value;
                      },
                      value: controller.rememberMe.value,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                      side: BorderSide(width: 0.5, color: Colors.grey.shade400),
                      activeColor: color.primary,
                      checkColor: Colors.white,
                    ),
                  ),
                  Text(
                    'Remember me'.tr,
                    style: TextStyle(color: color.secondary),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              MyButton(
                label: 'Log In',
                onPressed: controller.onLogin,
                radius: 7,
                height: 40,
                fontSize: 16,
                isBold: true,
                fontColor: color.tertiary,
                color: color.primary,
              ),
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Forget password?'.tr,
                  style: TextStyle(color: Color(0xFF0866ff)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
