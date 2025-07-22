import 'package:facebook_clone/controllers/request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MobileRequestMobile extends GetView<RequestController> {
  const MobileRequestMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your friends'.tr),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: CustomScrollView(slivers: []),
    );
  }
}
