import 'package:facebook_clone/views/friend_screen/friend_controller.dart';
import 'package:get/get.dart';

class FriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FriendController());
  }
}
