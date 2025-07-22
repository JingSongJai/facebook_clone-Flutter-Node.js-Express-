import 'package:facebook_clone/views/menu_screen/layouts/menu_mobile.dart';
import 'package:facebook_clone/views/menu_screen/layouts/menu_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebMenuScreen() : MobileMenuScreen();
  }
}
