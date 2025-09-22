import 'package:data_learns_247/features/quiz/data/dto/end_quiz_payload.dart';
import 'package:data_learns_247/features/quiz/data/models/attempt_model.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_information_model.dart';
import 'package:data_learns_247/features/quiz/data/response/end_quiz_response.dart';
import 'package:data_learns_247/features/quiz/data/response/start_quiz_response.dart';

abstract class QuizRepository {
  Future<QuizInformation?> getQuizInformation(String id);
  Future<StartQuizResponse?> startQuiz(String id);
  Future<EndQuizResponse?> endQuiz(EndQuizPayload data);
  Future<Attempt?> getAttemptDetail(String id);
}