class Meta {
  String? fullName;
  String? email;
  String? userCity;
  String? userOrganization;
  String? userYearOfBirth;

  Meta({this.fullName, this.email, this.userCity, this.userOrganization, this.userYearOfBirth});

  Meta.fromJson(Map<String, dynamic> json) {
    fullName = json['full_name'];
    email = json ['email'];
    userCity = json['user_city'];
    userOrganization = json['user_organization'];
    userYearOfBirth = json['user_year_of_birth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['full_name'] = fullName;
    data ['email'] = email;
    data['user_city'] = userCity;
    data['user_organization'] = userOrganization;
    data['user_year_of_birth'] = userYearOfBirth;
    return data;
  }
}