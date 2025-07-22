import 'package:dio/dio.dart' as http;
import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/services/api_client.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/utils/utils.dart';
import 'package:get/get.dart';

class UserService {
  Future<void> login(String username, String password) async {
    await Utils.runSafely(() async {
      var response = await ApiClient.dio.post(
        'api/user/login',
        data: {'username': username, 'password': password},
      );

      var token = response.data['token'];
      var refreshToken = response.data['refreshToken'];

      await ApiClient.secureStorage.write(key: 'token', value: token);
      await ApiClient.secureStorage.write(
        key: 'refreshToken',
        value: refreshToken,
      );

      Get.find<AuthService>().setToken(token);
    });
  }

  Future<void> register(Map<String, dynamic> map) async {
    await Utils.runSafely(() async {
      var response = await ApiClient.dio.post(
        'api/user/register',
        data: http.FormData.fromMap(map),
      );

      if (response.statusCode == 200) {
        Get.showSnackbar(
          GetSnackBar(message: 'Registration successful! Please login.'),
        );
      }
    });
  }

  Future<UserModel?> profile([String? id]) async {
    return await Utils.runSafely(() async {
      var response = await ApiClient.dio.get(
        'api/user/profile',
        queryParameters: {if (id != null) 'id': id},
      );

      var user = UserModel.fromJson(response.data['data']);

      if (id == null) Get.find<AuthService>().setUser(user);

      print(AuthService.to.user!.avatarUrl);
      return user;
    });
  }

  Future<List<UserModel>> getUsers({
    bool other = false,
    bool friend = false,
    bool request = false,
    String name = '',
    String id = '',
    int? sort,
  }) async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.get(
            'api/user',
            queryParameters: {
              if (id.isNotEmpty) 'userId': id,
              if (other) 'other': 'true',
              if (friend) 'friend': 'true',
              if (request) 'request': 'request',
              'name': name,
              if (sort != null) 'sort': sort,
            },
          );

          if (response.statusCode == 200) {
            var users =
                (response.data['data'] as List)
                    .map((user) => UserModel.fromJson(user))
                    .toList();

            return users;
          }
        }) ??
        [];
  }

  Future<bool> addFriend(String id) async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.post(
            'api/user/friend',
            data: {'userId': id},
          );

          if (response.statusCode == 200) return true;
        }) ??
        false;
  }

  Future<bool> acceptFriend(String id) async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.put(
            'api/user/friend/accept',
            data: {'userId': id},
          );

          if (response.statusCode == 200) return true;
        }) ??
        false;
  }

  Future<bool> removeFriend(String id) async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.delete(
            'api/user/friend/remove',
            data: {'userId': id},
          );

          if (response.statusCode == 200) return true;
        }) ??
        false;
  }

  Future<bool> cancelFriend(String id) async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.delete(
            'api/user/friend/cancel',
            data: {'userId': id},
          );

          if (response.statusCode == 200) return true;
        }) ??
        false;
  }

  Future<bool> updateImage(
    Map<String, dynamic> data, [
    bool isProfile = false,
  ]) async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.put(
            '/api/user/image',
            data: http.FormData.fromMap(data),
            queryParameters: {if (isProfile) 'profile': 'true'},
          );

          if (response.statusCode == 200) {
            return true;
          }
        }) ??
        false;
  }
}
