import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/provider/query_parameter.dart';
import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/dto/end_quiz_payload.dart';
import 'package:data_learns_247/features/quiz/data/models/attempt_model.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_information_model.dart';
import 'package:data_learns_247/features/quiz/data/response/end_quiz_response.dart';
import 'package:data_learns_247/features/quiz/data/response/start_quiz_response.dart';

class QuizRepositoryImpl implements QuizRepository {

  @override
  Future<QuizInformation?> getQuizInformation(String id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.quizInformation,
        useBearer: true,
        queryParam: QP.quizQP(id: id)
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => QuizInformation.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StartQuizResponse?> startQuiz(String id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        baseUrl: API.publicBaseAPI,
        endpoint: API.startQuiz,
        useBearer: true,
        queryParam: QP.startQuizQP(id: id)
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => StartQuizResponse.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<EndQuizResponse?> endQuiz(EndQuizPayload data) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        baseUrl: API.publicBaseAPI,
        endpoint: API.endQuiz,
        useBearer: true,
        body: data.toJson()
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => EndQuizResponse.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Attempt?> getAttemptDetail(String id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.quizAttempt,
        useBearer: true,
        queryParam: QP.attemptQuizQP(id: id)
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => Attempt.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}