import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/implementation/quiz_repository_impl.dart';
import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_data_model.dart';
import 'package:data_learns_247/features/quiz/data/response/start_quiz_response.dart';
import 'package:data_learns_247/features/quiz/domains/use_cases/start_quiz_use_case.dart';
import 'package:equatable/equatable.dart';

part 'start_quiz_state.dart';

class StartQuizCubit extends Cubit<StartQuizState> {
  final QuizRepository _quizRepository = QuizRepositoryImpl();

  StartQuizCubit() : super(StartQuizInitial());

  void startQuiz(String id) async {
    try {
      emit(StartQuizLoading());

      StartQuizResponse? startQuizResponse = await StartQuiz(id, _quizRepository).call();

      if (startQuizResponse != null) {
        emit(StartQuizCompleted(startQuizResponse));
      } else {
        emit(const StartQuizError('Start quiz failed'));
      }
    } catch (e) {
      emit(StartQuizError(e.toString()));
    }
  }
}