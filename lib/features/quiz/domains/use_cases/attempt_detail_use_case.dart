import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/models/attempt_model.dart';

class GetAttemptDetail {
  final String _id;
  final QuizRepository _quizRepository;

  GetAttemptDetail(this._id, this._quizRepository);

  Future<Attempt?> call() async {
    return await _quizRepository.getAttemptDetail(_id);
  }
}