import 'package:facebook_clone/views/setting_screen/layouts/setting_mobile.dart';
import 'package:facebook_clone/views/setting_screen/layouts/setting_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebSettingScreen() : MobileSettingScreen();
  }
}
