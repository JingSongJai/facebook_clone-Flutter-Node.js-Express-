import 'package:facebook_clone/views/post_screen/post_controller.dart';
import 'package:get/get.dart';

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostController());
  }
}
