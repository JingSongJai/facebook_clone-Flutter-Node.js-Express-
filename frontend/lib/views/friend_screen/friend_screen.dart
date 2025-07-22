import 'package:facebook_clone/views/friend_screen/layouts/friend_mobile.dart';
import 'package:facebook_clone/views/friend_screen/layouts/friend_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FriendScreen extends StatelessWidget {
  const FriendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? WebFriendScreen() : MobileFriendScreen();
  }
}
