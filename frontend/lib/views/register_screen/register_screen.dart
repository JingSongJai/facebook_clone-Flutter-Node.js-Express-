import 'package:facebook_clone/views/register_screen/layouts/register_mobile.dart';
import 'package:facebook_clone/views/register_screen/layouts/register_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? const WebRegisterScreen() : const MobileRegisterScreen();
  }
}
