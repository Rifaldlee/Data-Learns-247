part of 'quiz_logic_cubit.dart';

class QuizLogicState extends Equatable {
  final QuizData quizData;
  final int currentIndex;
  final Map<int, String> selectedAnswers;
  final Map<int, List<String>> userAnswers;

  const QuizLogicState({
    required this.quizData,
    required this.currentIndex,
    required this.selectedAnswers,
    required this.userAnswers,
  });

  QuizLogicState copyWith({
    QuizData? quizData,
    int? currentIndex,
    Map<int, String>? selectedAnswers,
    Map<int, List<String>>? userAnswers
  }) {
    return QuizLogicState(
      quizData: quizData ?? this.quizData,
      currentIndex: currentIndex ?? this.currentIndex,
      selectedAnswers: selectedAnswers ?? this.selectedAnswers,
      userAnswers: userAnswers ?? this.userAnswers
    );
  }

  @override
  List<Object> get props => [quizData, currentIndex, selectedAnswers, userAnswers];
}