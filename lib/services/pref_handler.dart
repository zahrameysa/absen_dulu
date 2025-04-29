import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _tokenKey = "token";
  static const String _emailKey = "email";
  static const String _nameKey = "name";

  static void saveToken(String token) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_tokenKey, token);
    });
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? '';
  }

  static void removeToken() async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.clear();
    });
  }

  static void saveEmail(String email) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_emailKey, email);
    });
  }

  static Future<String> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_emailKey) ?? '';
  }

  static void saveName(String name) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_nameKey, name);
    });
  }

  static Future<String> getName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_nameKey) ?? '';
  }
}
