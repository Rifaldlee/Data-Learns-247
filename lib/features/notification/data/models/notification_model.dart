class Notification {
  String? status;
  List<Data>? data;

  Notification({this.status, this.data});

  Notification.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? message;
  String? type;
  String? referenceId;
  bool? isRead;
  int? timestamp;
  String? date;

  Data({
    this.id,
    this.message,
    this.type,
    this.referenceId,
    this.isRead,
    this.timestamp,
    this.date
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    type = json['type'];
    referenceId = json['reference_id'];
    isRead = json['is_read'];
    timestamp = json['timestamp'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['message'] = message;
    data['type'] = type;
    data['reference_id'] = referenceId;
    data['is_read'] = isRead;
    data['timestamp'] = timestamp;
    data['date'] = date;
    return data;
  }
}