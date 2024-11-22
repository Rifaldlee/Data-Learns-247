import 'package:nb_utils/nb_utils.dart';

const String _jwt = 'jwt';
const String _email = 'email';
const String _userId = 'id';
const String _cookie = 'cookie';

class SharedPrefUtil {

  static void storeJwtToken(String jwt) async {
    sharedPreferences.setString(_jwt, jwt);
  }

  static String getJwtToken() {
    return sharedPreferences.getString(_jwt) ?? "";
  }

  static void storeEmail(String email) async {
    sharedPreferences.setString(_email, email);
  }

  static String getEmail() {
    return sharedPreferences.getString(_email) ?? "";
  }

  static void storeUserId(String userId) async {
    sharedPreferences.setString(_userId, userId);
  }

  static String getUserId() {
    return sharedPreferences.getString(_userId) ?? "";
  }

  static void storeCookie(String cookie) async {
    sharedPreferences.setString(_cookie, cookie);
  }

  static String getCookie() {
    return sharedPreferences.getString(_cookie) ?? "";
  }
}