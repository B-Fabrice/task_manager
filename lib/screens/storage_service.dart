import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static String modeKey = 'mode';

  static Future<void> setMode(String? mode) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    if (mode == null) {
      pref.remove(modeKey);
      return;
    }
    pref.setString(modeKey, mode);
  }

  static Future<String?> getMode() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? data = pref.getString(modeKey);
    return data;
  }
}
