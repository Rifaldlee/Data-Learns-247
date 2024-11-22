class RegisterRequestPayload {
  String userName;
  String email;
  String password;
  String fullName;
  String city;
  String organization;
  String yearOfBirth;

  RegisterRequestPayload({
    required this.userName,
    required this.email,
    required this.password,
    required this.fullName,
    required this.city,
    required this.organization,
    required this.yearOfBirth
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = userName;
    map['email'] = email;
    map['password'] = password;
    map['full_name'] = fullName;
    map['user_city'] = city;
    map['user_organization'] = organization;
    map['user_year_of_birth'] = yearOfBirth;
    return map;
  }
}
