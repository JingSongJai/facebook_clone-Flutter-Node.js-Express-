import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/services/user_service.dart';
import 'package:get/get.dart';

class FriendController extends GetxController {
  final friends = <UserModel>[].obs;
  final requests = <UserModel>[].obs;
  final isLoading = false.obs;

  Future<void> getUsers() async {
    isLoading.value = true;
    friends.value = await UserService().getUsers(other: true);
    requests.value = await UserService().getUsers(request: true);
    isLoading.value = false;
  }

  @override
  void onInit() {
    getUsers();
    super.onInit();
  }
}
