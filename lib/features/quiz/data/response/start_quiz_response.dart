import 'package:data_learns_247/features/quiz/data/models/quiz_data_model.dart';

class StartQuizResponse {
  String? status;
  int? code;
  String? message;
  QuizData? data;

  StartQuizResponse({this.status, this.code, this.message, this.data});

  StartQuizResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? QuizData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['code'] = code;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}