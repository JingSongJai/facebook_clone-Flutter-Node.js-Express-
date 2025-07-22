import 'package:facebook_clone/models/notification_model.dart';
import 'package:facebook_clone/services/api_client.dart';
import 'package:facebook_clone/utils/utils.dart';

class NotificationService {
  Future<List<NotificationModel>> getNotifications() async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.get('/api/notification');

          if (response.statusCode == 200) {
            return (response.data['data'] as List)
                .map((notify) => NotificationModel.fromJson(notify))
                .toList();
          }
        }) ??
        [];
  }
}
