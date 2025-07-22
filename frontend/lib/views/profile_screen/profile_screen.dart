import 'package:facebook_clone/views/profile_screen/layouts/profile_mobile.dart';
import 'package:facebook_clone/views/profile_screen/layouts/profile_web.dart';
import 'package:facebook_clone/views/profile_screen/profile_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? const WebProfileScreen() : MobileProfileScreen();
  }
}
