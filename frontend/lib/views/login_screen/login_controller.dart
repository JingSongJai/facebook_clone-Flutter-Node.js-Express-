import 'package:facebook_clone/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final languages = [
    'English (US)',
    'ភាសាខ្មែរ', // Khmer
    'Español', // Spanish
    'Français', // French
    'Deutsch', // German
    '中文 (简体)', // Chinese (Simplified)
    '日本語', // Japanese
    '한국어', // Korean
    'Português (Brasil)', // Portuguese (Brazil)
    'Русский', // Russian
    'Italiano', // Italian
    'Türkçe', // Turkish
    'ภาษาไทย', // Thai
    'العربية', // Arabic
    'हिन्दी', // Hindi
    'Tiếng Việt', // Vietnamese
  ];
  final selectedLanguage = 'English (US)'.obs;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final blurRadius = 0.0.obs;
  final rememberMe = false.obs;
  final hidePassword = false.obs;
  final formKey = GlobalKey<FormState>();
  final RxnString errorText = RxnString(null);

  Future<void> onLogin() async {
    await UserService().login(usernameController.text, passwordController.text);
  }
}
