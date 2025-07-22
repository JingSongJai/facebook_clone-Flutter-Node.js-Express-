import 'package:facebook_clone/views/view_friend_screen/view_friend_controller.dart';
import 'package:get/get.dart';

class ViewFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ViewFriendController());
  }
}
