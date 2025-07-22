import 'package:dio/dio.dart' as http;
import 'package:facebook_clone/models/post_model.dart';
import 'package:facebook_clone/services/api_client.dart';
import 'package:facebook_clone/utils/utils.dart';
import 'package:flutter/foundation.dart';

class PostService {
  Future<List<PostModel>> getPosts([String? id]) async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.get(
            'api/post/filter?user=${id ?? ''}',
          );
          return (response.data['data'] as List)
              .map((data) => PostModel.fromJson(data))
              .toList();
        }) ??
        [];
  }

  Future<List<PostModel>> getUserPosts() async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.get('api/post');

          return (response.data['data'] as List)
              .map((data) => PostModel.fromJson(data))
              .toList();
        }) ??
        [];
  }

  Future<PostModel?> likePost(String reactType, String id) async {
    return await Utils.runSafely(() async {
      var response = await ApiClient.dio.post(
        'api/post/like/$id',
        data: {'reactType': reactType},
      );

      return PostModel.fromJson(response.data['data']);
    });
  }

  Future<PostModel?> unLikePost(String reactType, String id) async {
    return await Utils.runSafely(() async {
      var response = await ApiClient.dio.post(
        'api/post/unlike/$id',
        data: {'reactType': reactType},
      );

      return PostModel.fromJson(response.data['data']);
    });
  }

  Future<void> createPost(Map<String, dynamic> data) async {
    try {
      await ApiClient.dio.post('api/post', data: http.FormData.fromMap(data));
    } on http.DioException catch (e) {
      debugPrint("Status: ${e.response?.statusCode}");
      debugPrint("Error Data: ${e.response?.data}");
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  Future<PostModel?> addComment(String text, String id) async {
    return await Utils.runSafely(() async {
      var response = await ApiClient.dio.post(
        'api/post/comment/$id',
        data: {'text': text},
      );

      final post = PostModel.fromJson(response.data['data']);

      return post;
    });
  }
}
