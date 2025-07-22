import 'package:facebook_clone/views/home_screen/layouts/home_mobile.dart';
import 'package:facebook_clone/views/home_screen/layouts/home_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebHomeScreen() : MobileHomeScreen();
  }
}
