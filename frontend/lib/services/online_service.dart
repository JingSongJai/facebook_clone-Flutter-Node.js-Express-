import 'package:facebook_clone/services/api_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class OnlineService extends GetxService {
  final ids = <String>{}.obs;

  @override
  void onInit() {
    connectSocket();
    super.onInit();
  }

  void connectSocket() async {
    final token = await ApiClient.secureStorage.read(key: 'token');

    io.Socket socket = io.io(
      kIsWeb ? dotenv.env['API_URL']! : dotenv.env['API_URL_MOBILE']!,
      io.OptionBuilder()
          .setTransports(['websocket']) // Required for Flutter web
          .disableAutoConnect()
          .setAuth({'token': token})
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      debugPrint('🟢 Connected');
      socket.emit('test', 'yourUserId123'); // Send your ID here
    });

    socket.on('online', (data) {
      ids.addAll((data['friends'] as List).map((id) => id.toString()).toSet());
      debugPrint('👥 Online users updated: $data');
    });

    socket.on('friend_online', (data) {
      ids.add(data['id'].toString());
      debugPrint('User $data online');
    });

    socket.on('friend_offline', (data) {
      ids.remove(data['id'].toString());
      debugPrint('User $data offline');
    });

    socket.on('notification', (data) {
      debugPrint(data);
    });

    socket.onDisconnect((_) => debugPrint('🔴 Disconnected'));
  }
}
