class LoginRequestPayload {
  String? email;
  String? password;

  LoginRequestPayload({this.email, this.password,});

  LoginRequestPayload.fromJson(dynamic json) {
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    return map;
  }
}