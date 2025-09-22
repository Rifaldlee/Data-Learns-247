import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/implementation/quiz_repository_impl.dart';
import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/dto/end_quiz_payload.dart';
import 'package:data_learns_247/features/quiz/data/response/end_quiz_response.dart';
import 'package:data_learns_247/features/quiz/domains/use_cases/end_quiz_use_case.dart';
import 'package:equatable/equatable.dart';

part 'end_quiz_state.dart';

class EndQuizCubit extends Cubit<EndQuizState> {
  final QuizRepository _quizRepository = QuizRepositoryImpl();

  EndQuizCubit() : super(EndQuizInitial());

  void endQuiz(EndQuizPayload data) async {
    try {
      emit(EndQuizLoading());

      EndQuizResponse? endQuizResponse = await EndQuiz(_quizRepository).call(data);

      if (endQuizResponse != null) {
        emit(EndQuizCompleted(endQuizResponse));
      } else {
        emit(const EndQuizError('End quiz failed'));
      }
    } catch (e) {
      emit(EndQuizError(e.toString()));
    }
  }
}