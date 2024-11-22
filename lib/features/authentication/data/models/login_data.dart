import 'package:nb_utils/nb_utils.dart';

class LoginData {
  String? jwt;
  String? message;
  int? errorCode;

  LoginData({this.jwt});

  LoginData.fromJson(dynamic json) {
    jwt = json['jwt'];
    message = json['message'];
    errorCode = json['errorCode'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if(!jwt.isEmptyOrNull){
      map['jwt'] = jwt;
    } else {
      map['message'] = message;
      map['errorCode'] = errorCode;
    }
    return map;
  }
}