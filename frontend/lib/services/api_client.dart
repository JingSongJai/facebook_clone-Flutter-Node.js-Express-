import 'package:dio/dio.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ApiClient {
  ApiClient._();

  static final dio = Dio(
    BaseOptions(
      baseUrl: kIsWeb ? dotenv.env['API_URL']! : dotenv.env['API_URL_MOBILE']!,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
    ),
  );
  static CancelToken cancelToken = CancelToken();
  static final secureStorage = FlutterSecureStorage();

  static void init() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // add cancel token
          options.cancelToken = cancelToken;

          // add access token
          final accessToken = await secureStorage.read(key: 'token');

          if (accessToken != null) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 403 &&
              error.response?.data['error'] == 'jwt expired' &&
              !(error.requestOptions.extra['retried'] ?? false)) {
            try {
              final refreshToken = await secureStorage.read(
                key: 'refreshToken',
              );

              //set retried value to check
              error.requestOptions.extra['retried'] = true;

              if (refreshToken == null) {
                return handler.reject(error);
              }

              final refreshDio = Dio(BaseOptions(baseUrl: dio.options.baseUrl));

              final response = await refreshDio.post(
                'api/user/refresh',
                data: {'refreshToken': refreshToken},
              );

              var newAccessToken = response.data['accessToken'].toString();

              await secureStorage.write(key: 'token', value: newAccessToken);

              //resend request
              final requestOptions = error.response!.requestOptions;
              requestOptions.headers['Authorization'] =
                  'Bearer $newAccessToken';
              final clonedRequest = await dio.fetch(requestOptions);
              return handler.resolve(clonedRequest);
            } catch (err) {
              Get.find<AuthService>().logout();
              return handler.reject(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }
}
