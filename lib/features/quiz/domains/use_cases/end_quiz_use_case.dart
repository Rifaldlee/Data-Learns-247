import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/dto/end_quiz_payload.dart';
import 'package:data_learns_247/features/quiz/data/response/end_quiz_response.dart';

class EndQuiz {
  final QuizRepository _quizRepository;

  EndQuiz(this._quizRepository);

  Future<EndQuizResponse?> call(EndQuizPayload data) async {
    return await _quizRepository.endQuiz(data);
  }
}