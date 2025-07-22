import 'package:facebook_clone/views/login_screen/layouts/login_mobile.dart';
import 'package:facebook_clone/views/login_screen/layouts/login_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebLoginScreen() : MobileLoginScreen();
  }
}
