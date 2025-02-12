import 'package:nb_utils/nb_utils.dart';

const String _jwt = 'jwt';
const String _email = 'email';
const String _userId = 'id';
const String _cookie = 'cookie';
const String _notificationType = 'notification_type';
const String _notificationId = 'notification_id';
const String _notificationHasVideo = 'notification_has_video';

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

  static Future<void> storeNotificationData(Map<String, dynamic> data) async {
    await sharedPreferences.setString(_notificationType, data['type']);
    await sharedPreferences.setString(_notificationId, data['id']);
    if (data['type'] == 'article') {
      await sharedPreferences.setBool(_notificationHasVideo, data['has_video']);
    }
  }

  static bool hasNotificationData() {
    return sharedPreferences.containsKey(_notificationType) &&
        sharedPreferences.containsKey(_notificationId);
  }

  static Map<String, dynamic>? getNotificationData() {
    if (!hasNotificationData()) return null;

    final type = sharedPreferences.getString(_notificationType);
    final id = sharedPreferences.getString(_notificationId);
    final hasVideo = sharedPreferences.getBool(_notificationHasVideo);

    return {
      'type': type,
      'id': id,
      if (type == 'article') 'has_video': hasVideo
    };
  }

  static Future<void> clearNotificationData() async {
    await sharedPreferences.remove(_notificationType);
    await sharedPreferences.remove(_notificationId);
    await sharedPreferences.remove(_notificationHasVideo);
  }
}