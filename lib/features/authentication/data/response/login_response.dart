import '../models/login_data.dart';

class LoginResponse {
  bool? success;
  LoginData? data;

  LoginResponse({this.success, this.data,});

  LoginResponse.fromJson(dynamic json) {
    success = json['success'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
}