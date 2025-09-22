import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_information_model.dart';

class GetQuizInformation {
  final String _id;
  final QuizRepository _quizRepository;

  GetQuizInformation(this._id, this._quizRepository);

  Future<QuizInformation?> call() async {
    return await _quizRepository.getQuizInformation(_id);
  }
}