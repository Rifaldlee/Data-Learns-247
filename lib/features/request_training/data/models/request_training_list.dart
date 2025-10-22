class RequestTrainingList {
  int? id;
  String? productName;
  String? dateCreated;
  String? status;

  RequestTrainingList({
    this.id,
    this.productName,
    this.dateCreated,
    this.status
  });

  RequestTrainingList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productName = json['product_name'];
    dateCreated = json['date_created'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_name'] = productName;
    data['date_created'] = dateCreated;
    data['status'] = status;
    return data;
  }
}
