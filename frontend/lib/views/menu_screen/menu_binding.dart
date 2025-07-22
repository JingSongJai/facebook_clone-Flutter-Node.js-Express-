import 'package:facebook_clone/controllers/request_controller.dart';
import 'package:facebook_clone/services/online_service.dart';
import 'package:facebook_clone/views/friend_screen/friend_controller.dart';
import 'package:facebook_clone/views/home_screen/home_controller.dart';
import 'package:facebook_clone/views/menu_screen/menu_controller.dart';
import 'package:facebook_clone/views/profile_screen/profile_controller.dart';
import 'package:facebook_clone/views/setting_screen/setting_controller.dart';
import 'package:get/get.dart';

class MenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MenuScreenController());
    Get.put(HomeController());
    Get.put(ProfileController());
    Get.put(FriendController());
    Get.put(RequestController());
    Get.put(OnlineService());
    Get.put(SettingController());
  }
}
