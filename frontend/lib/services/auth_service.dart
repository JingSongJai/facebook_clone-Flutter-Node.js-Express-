import 'package:facebook_clone/models/user_model.dart';
import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/services/api_client.dart';
import 'package:facebook_clone/services/user_service.dart';
import 'package:facebook_clone/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final _token = RxnString();
  final _user = Rxn<UserModel?>();

  String? get token => _token.value;
  UserModel? get user => _user.value;

  static AuthService get to => Get.find();

  void setToken(String? token) async {
    _token.value = token;

    if (_token.value != null) {
      await ApiClient.secureStorage.write(key: 'token', value: token);
    } else {
      await ApiClient.secureStorage.delete(key: 'token');
    }
  }

  void setUser(UserModel? user) async {
    _user.value = user;
  }

  void logout() async {
    _token.value = null;
    _user.value = null;
    await ApiClient.secureStorage.deleteAll();
  }

  @override
  void onReady() async {
    ever(_token, (value) async {
      if (value == null) {
        if (Get.currentRoute != AppPage.login) {
          Get.offAllNamed(AppPage.login);
        }
      } else {
        Utils.showOverlay(
          Get.overlayContext!,
          CircularProgressIndicator.adaptive(),
        );
        await UserService().profile();
        Utils.hideOverlay();
        Get.offAllNamed(AppPage.home);
      }
    });
    _token.value = await ApiClient.secureStorage.read(key: 'token');
    super.onReady();
  }
}
