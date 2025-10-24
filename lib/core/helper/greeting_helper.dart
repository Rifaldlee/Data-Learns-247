import 'package:data_learns_247/features/greeting/greeting_model.dart';

extension GreetingHelper on Greeting {

  String? getTime() {
    final hour = DateTime.now().hour;

    if (hour >= 4 && hour < 11) { // pagi (04:00–10:59)
      return 'pagi';
    } else if (hour >= 11 && hour < 15) { // siang (11:00–14:59)
      return 'siang';
    } else if (hour >= 15 && hour < 18) { // sore (15:00–17:59)
      return 'sore';
    } else { // malam (18:00–04:59)
      return 'malam';
    }
  }

  String? getImageByTime() {
    final time = getTime();
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

  String? getTextByTime() {
    final time = getTime();
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