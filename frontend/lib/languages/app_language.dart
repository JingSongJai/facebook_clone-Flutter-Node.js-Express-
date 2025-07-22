import 'package:facebook_clone/languages/en.dart';
import 'package:facebook_clone/languages/km.dart';
import 'package:get/get.dart';

class AppLanguage extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {'en': en, 'km': km};
}
