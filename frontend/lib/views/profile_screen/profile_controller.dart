import 'package:facebook_clone/models/post_model.dart';
import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/services/post_service.dart';
import 'package:facebook_clone/services/user_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final user = Get.find<AuthService>().user.obs;
  final isLoading = false.obs;
  final selectedIndex = 0.obs;
  final posts = <PostModel>[].obs;
  final friends = <UserModel>[].obs;

  final List<String> tabs = ['Post', 'Photos', 'Videos'];
  final id = RxnString(null);

  Future<void> getUserPosts() async {
    isLoading.value = true;
    posts.value = await PostService().getUserPosts();
    isLoading.value = false;
  }

  Future<void> getPosts() async {
    id.value = Get.parameters['id'];
    isLoading.value = true;
    posts.value = await PostService().getPosts(id.value ?? user.value?.id);
    isLoading.value = false;
  }

  void refreshUser([bool isUser = false]) async {
    user.value = Get.find<AuthService>().user;
    if (isUser) Get.parameters.remove('id');
    await getPosts();
  }

  Future<void> getFriends([String id = '']) async {
    isLoading.value = true;
    friends.value = await UserService().getUsers(friend: true, id: id);
    isLoading.value = false;
  }

  @override
  void onInit() async {
    await getPosts();
    await getFriends();
    super.onInit();
  }
}
