import 'package:dio/dio.dart';
import 'package:facebook_clone/models/story_model.dart';
import 'package:facebook_clone/services/api_client.dart';
import 'package:facebook_clone/utils/utils.dart';

class StoryService {
  Future<bool> addStory(Map<String, dynamic> data) async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.post(
            '/api/story',
            data: FormData.fromMap(data),
          );

          if (response.statusCode == 200) return true;
        }) ??
        false;
  }

  Future<List<StoryModel>> getStories() async {
    return await Utils.runSafely(() async {
          var response = await ApiClient.dio.get('/api/story');

          return (response.data['data'] as List)
              .map((story) => StoryModel.fromJson(story))
              .toList();
        }) ??
        [];
  }
}
