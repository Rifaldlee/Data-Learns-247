import 'package:data_learns_247/features/greeting/greeting_model.dart';

extension GreetingHelper on Greeting {
  String? getImageByTime(String time) {
    switch (time) {
      case 'pagi':
        return pagi?.image;
      case 'siang':
        return siang?.image;
      case 'sore':
        return sore?.image;
      case 'malam':
        return malam?.image;
      default:
        return null;
    }
  }

  String? getTextByTime(String time) {
    switch (time) {
      case 'pagi':
        return pagi?.text;
      case 'siang':
        return siang?.text;
      case 'sore':
        return sore?.text;
      case 'malam':
        return malam?.text;
      default:
        return null;
    }
  }
}