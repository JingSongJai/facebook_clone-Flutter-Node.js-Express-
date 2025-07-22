import 'package:facebook_clone/models/post_model.dart';
import 'package:facebook_clone/models/story_model.dart';
import 'package:facebook_clone/services/post_service.dart';
import 'package:facebook_clone/services/story_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final isLoading = false.obs;
  final posts = <PostModel>[].obs;
  final stories = <StoryModel>[].obs;
  final RxInt counter = 0.obs;

  final scrollController = ScrollController();

  Future<void> getPosts() async {
    isLoading.value = true;
    update();
    posts.value = await PostService().getPosts();
    isLoading.value = false;
    update();
  }

  Future<void> getStories() async {
    isLoading.value = true;
    stories.value = await StoryService().getStories();
    isLoading.value = false;
  }

  @override
  void onReady() async {
    await getPosts();
    await getStories();

    super.onReady();
  }
}
