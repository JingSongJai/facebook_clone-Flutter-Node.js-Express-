import 'package:facebook_clone/views/post_screen/layouts/post_mobile.dart';
import 'package:facebook_clone/views/post_screen/layouts/post_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebPostScreen() : MobilePostScreen();
  }
}
