import 'dart:async';
import 'package:dio/dio.dart';
import 'package:facebook_clone/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class Utils {
  Utils._();

  static OverlayEntry? overlayEntry;
  static late final StreamSubscription<InternetStatus> listener;

  static durationAgo(DateTime startTime, DateTime endTime) {
    Duration diff = endTime.difference(startTime);

    if (diff.inDays > 0) {
      return "${diff.inDays}d";
    } else if (diff.inHours > 0) {
      return "${diff.inHours}h";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes}mn";
    } else {
      return "Just now";
    }
  }

  static int calculateNumberOfLines({
    required String text,
    required TextStyle style,
    required double maxWidth,
  }) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      maxLines: null,
      textDirection: TextDirection.ltr,
    );
    tp.layout(maxWidth: maxWidth);

    final lineHeight = tp.preferredLineHeight;
    final lines = (tp.size.height / lineHeight).ceil();
    return lines;
  }

  static void showOverlay(BuildContext context, Widget widget) {
    if (overlayEntry != null) {
      overlayEntry!.remove();
    }

    overlayEntry = OverlayEntry(
      builder:
          (context) => Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Container(color: Colors.black38),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: widget,
                  ),
                ),
              ],
            ),
          ),
    );

    Overlay.of(context).insert(overlayEntry!);
  }

  static void hideOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }

  static Widget getReactions(List<LikeModel> likes) {
    List<Map<String, dynamic>> reactCount = [
      {
        'name': 'Like',
        'count': likes.where((like) => like.reactType == 'Like').length,
      },
      {
        'name': 'Love',
        'count': likes.where((like) => like.reactType == 'Love').length,
      },
      {
        'name': 'Care',
        'count': likes.where((like) => like.reactType == 'Care').length,
      },
      {
        'name': 'Laugh',
        'count': likes.where((like) => like.reactType == 'Laugh').length,
      },
      {
        'name': 'Wow',
        'count': likes.where((like) => like.reactType == 'Wow').length,
      },
      {
        'name': 'Sad',
        'count': likes.where((like) => like.reactType == 'Sad').length,
      },
      {
        'name': 'Angry',
        'count': likes.where((like) => like.reactType == 'Angry').length,
      },
    ];

    reactCount.sort((a, b) => b['count'].compareTo(a['count']));
    reactCount.removeWhere((item) => item['count'] == 0);

    final displayCount = reactCount.length >= 3 ? 3 : reactCount.length;

    return SizedBox(
      height: 30,
      width: 17.0 * displayCount + 10,
      child: Stack(
        children: List.generate(displayCount, (index) {
          return Positioned(
            left: index * 16,
            top: 0,
            child: Image.asset(
              'assets/icons/${reactCount[index]['name']}-active.png',
              width: 30,
              height: 30,
              fit: BoxFit.cover,
            ),
          );
        }),
      ),
    );
  }

  static int getReactTypeCount(List<LikeModel> likes) {
    int count = 0;

    count = likes.map((like) => like.reactType).toSet().length;

    return count;
  }

  static void initConnectionChecker() {
    listener = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      switch (status) {
        case InternetStatus.connected:
          if (Get.isSnackbarOpen) Get.closeAllSnackbars();
          showSnackBar('Internet connected!');
          // hideOverlay();
          break;
        case InternetStatus.disconnected:
          showSnackBar('Internet disconnected!');
          // showOverlay(
          //   Get.overlayContext!,
          //   Column(
          //     spacing: 10,
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       Image.asset(
          //         'assets/icons/no-internet.png',
          //         width: 100,
          //         height: 100,
          //       ),
          //       Text(
          //         'Lost connection!',
          //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          //       ),
          //     ],
          //   ),
          // );
          // ApiClient.cancelToken.cancel('Lost connection!');
          // ApiClient.cancelToken = CancelToken();
          break;
      }
    });
  }

  static Future<T?> runSafely<T>(Future<T> Function() callback) async {
    try {
      return await callback();
    } on DioException catch (err) {
      if (CancelToken.isCancel(err)) {
        showSnackBar(err.message.toString());
      } else if (err.type == DioExceptionType.connectionError) {
        showSnackBar(err.message.toString());
      } else if (err.type == DioExceptionType.receiveTimeout) {
        showSnackBar(err.message.toString());
      } else if (err.type == DioExceptionType.sendTimeout) {
        showSnackBar(err.message.toString());
      } else {
        showSnackBar(err.message.toString());
        debugPrint("Status: ${err.response?.statusCode}");
        debugPrint("Error Data: ${err.response?.data}");
      }
    } catch (err) {
      showSnackBar(err.toString());
    }
    return null;
  }

  static void showSnackBar(String message) {
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(message),
        duration: const Duration(seconds: 5),
        animationDuration: const Duration(milliseconds: 300),
        mainButton: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Get.closeAllSnackbars(),
        ),
        maxWidth: Get.width * 0.9,
        borderRadius: 10,
        backgroundColor: Get.theme.colorScheme.surface,
        borderWidth: 0.5,
        boxShadows: [
          BoxShadow(
            blurRadius: 5,
            offset: Offset(1, 0),
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
