class Collection {
  String? href;

  Collection({this.href,});

  Collection.fromJson(dynamic json) {
    href = json['href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    return data;
  }
}