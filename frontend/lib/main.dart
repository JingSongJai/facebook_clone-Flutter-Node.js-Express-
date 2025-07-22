import 'package:facebook_clone/languages/app_language.dart';
import 'package:facebook_clone/pages/app_page.dart';
import 'package:facebook_clone/pages/get_page.dart';
import 'package:facebook_clone/services/api_client.dart';
import 'package:facebook_clone/services/auth_service.dart';
import 'package:facebook_clone/theme/dark.dart';
import 'package:facebook_clone/theme/light.dart';
import 'package:facebook_clone/utils/utils.dart';
import 'package:facebook_clone/utils/web_url_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Config url
  setPathUrlStrategy();

  // Load .env file
  await dotenv.load(fileName: '.env');

  Get.put(AuthService(), permanent: true);

  // init connection checker listener
  Utils.initConnectionChecker();

  // init dio
  ApiClient.init();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorObservers: [],
      debugShowCheckedModeBanner: false,
      getPages: AppGetPage.pages,
      initialRoute: AppPage.login,
      theme: light,
      darkTheme: dark,
      translations: AppLanguage(),
      defaultTransition: kIsWeb ? Transition.fade : null,
    );
  }
}
