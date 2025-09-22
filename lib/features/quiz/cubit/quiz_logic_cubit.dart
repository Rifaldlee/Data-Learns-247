import 'package:bloc/bloc.dart';
import 'package:data_learns_247/features/quiz/data/models/quiz_data_model.dart';
import 'package:equatable/equatable.dart';

part 'quiz_logic_state.dart';

class QuizLogicCubit extends Cubit<QuizLogicState> {
  QuizLogicCubit()
      : super(QuizLogicState(
    quizData: QuizData(),
    currentIndex: 0,
    selectedAnswers: const {},
    userAnswers: const {},
  ));

  void initializeQuiz(QuizData quizData) {
    print('quizData: ${state.quizData.attemptId}');
    print('User answers before initialization: ${state.userAnswers}');

    emit(state.copyWith(
      quizData: quizData,
      currentIndex: 0,
      selectedAnswers: {},
      userAnswers: {},
    ));
  }

  void selectAnswer(int questionId, String answerId) {
    final updatedSelected = Map<int, String>.from(state.selectedAnswers);
    updatedSelected[questionId] = answerId;

    final updatedUserAnswers = Map<int, List<String>>.from(state.userAnswers);
    updatedUserAnswers[questionId] = [answerId];

    emit(state.copyWith(
      selectedAnswers: updatedSelected,
      userAnswers: updatedUserAnswers,
    ));
  }

  void goToNext() {
    if (state.currentIndex < state.quizData.quizQuestions!.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }
  }

  void goToPrevious() {
    if (state.currentIndex > 0) {
      emit(state.copyWith(currentIndex: state.currentIndex - 1));
    }
  }

  void jumpTo(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  void clearQuiz() {
    print('Clearing quiz...');
    emit(QuizLogicState(
      quizData: QuizData(),
      currentIndex: 0,
      selectedAnswers: const {},
      userAnswers: const {},
    ));

    print('After clear:');
    print('quizData: ${state.quizData.attemptId}');
    print('currentIndex: ${state.currentIndex}');
    print('selectedAnswers: ${state.selectedAnswers}');
    print('userAnswers: ${state.userAnswers}');
  }
}