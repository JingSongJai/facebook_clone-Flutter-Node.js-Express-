import 'package:facebook_clone/models/notification_model.dart';
import 'package:facebook_clone/services/notification_service.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final notifications = <NotificationModel>[].obs;
  final isLoading = false.obs;

  static NotificationController get to => Get.find();

  Future<void> getNotifications() async {
    isLoading.value = true;
    update();
    notifications.value = await NotificationService().getNotifications();
    isLoading.value = false;
    update();
  }

  @override
  void onInit() async {
    await getNotifications();
    super.onInit();
  }
}
