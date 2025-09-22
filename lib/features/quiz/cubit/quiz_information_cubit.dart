import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/implementation/quiz_repository_impl.dart';
import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_information_model.dart';
import 'package:data_learns_247/features/quiz/domains/use_cases/quiz_information_use_case.dart';

part 'quiz_information_state.dart';

class QuizInformationCubit extends Cubit<QuizInformationState> {
  final QuizRepository _quizRepository = QuizRepositoryImpl();

  QuizInformationCubit() : super(QuizInformationInitial());

  Future<void> fetchQuizInformation(String id) async {
    try {
      emit(QuizInformationLoading());

      QuizInformation? quizInformation = await GetQuizInformation(id, _quizRepository).call();

      if (quizInformation != null) {
        emit(QuizInformationCompleted(quizInformation));
      } else {
        emit(const QuizInformationError('No data available'));
      }
    } catch (e) {
      emit(QuizInformationError(e.toString()));
    }
  }
}