import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/response/start_quiz_response.dart';

class StartQuiz {
  final String _id;
  final QuizRepository _quizRepository;

  StartQuiz(this._id, this._quizRepository);

  Future<StartQuizResponse?> call() async {
    return await _quizRepository.startQuiz(_id);
  }
}