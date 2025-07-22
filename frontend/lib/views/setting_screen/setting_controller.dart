import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  final shortcuts = [
    {'label': 'Memories', 'icon': Icon(Icons.access_time_filled_sharp)},
    {'label': 'Saved', 'icon': Icon(Icons.bookmark)},
    {'label': 'Groups', 'icon': Icon(Icons.group)},
    {'label': 'Reels', 'icon': Icon(Icons.movie)},
    {'label': 'Marketplace', 'icon': Icon(Icons.maps_home_work_outlined)},
    {'label': 'Find friends', 'icon': Icon(Icons.person)},
    {'label': 'Feeds', 'icon': Icon(Icons.feed_sharp)},
    {'label': 'Events', 'icon': Icon(Icons.event)},
  ];

  final darkMode = false.obs;
}
