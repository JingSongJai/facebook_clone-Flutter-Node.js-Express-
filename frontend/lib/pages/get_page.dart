import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/views/friend_screen/friend_binding.dart';
import 'package:facebook_clone/views/friend_screen/friend_screen.dart';
import 'package:facebook_clone/views/home_screen/home_screen.dart';
import 'package:facebook_clone/views/login_screen/login_binding.dart';
import 'package:facebook_clone/views/login_screen/login_screen.dart';
import 'package:facebook_clone/views/menu_screen/menu_binding.dart';
import 'package:facebook_clone/views/menu_screen/menu_screen.dart';
import 'package:facebook_clone/views/post_screen/post_binding.dart';
import 'package:facebook_clone/views/post_screen/post_screen.dart';
import 'package:facebook_clone/views/post_screen/view_post_screen.dart';
import 'package:facebook_clone/views/profile_screen/profile_binding.dart';
import 'package:facebook_clone/views/profile_screen/profile_screen.dart';
import 'package:facebook_clone/views/register_screen/register_binding.dart';
import 'package:facebook_clone/views/register_screen/register_screen.dart';
import 'package:facebook_clone/views/view_friend_screen/view_friend_binding.dart';
import 'package:facebook_clone/views/view_friend_screen/view_friend_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class AppGetPage {
  AppGetPage._();

  static List<GetPage> pages = [
    GetPage(
      name: AppPage.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppPage.home,
      page: () => kIsWeb ? HomeScreen() : MenuScreen(),
      binding: MenuBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppPage.register,
      page: () => RegisterScreen(),
      binding: RegisterBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppPage.post,
      page: () => PostScreen(),
      binding: PostBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: AppPage.profile,
      page: () => ProfileScreen(),
      binding: ProfileBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppPage.friend,
      page: () => FriendScreen(),
      binding: FriendBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppPage.viewFriend,
      page: () => ViewFriendScreen(),
      binding: ViewFriendBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppPage.viewPost,
      page: () => ViewPostScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
