import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/features/quiz/domains/use_cases/attempt_detail_use_case.dart';
import 'package:data_learns_247/core/repository/implementation/quiz_repository_impl.dart';
import 'package:data_learns_247/core/repository/quiz_repository.dart';
import 'package:data_learns_247/features/quiz/data/models/attempt_model.dart';

part 'attempt_detail_state.dart';

class AttemptDetailCubit extends Cubit<AttemptDetailState> {
  final QuizRepository _quizRepository = QuizRepositoryImpl();

  AttemptDetailCubit() : super(AttemptDetailInitial());

  Future<void> fetchAttemptDetail(String id) async{
    try {
      emit(AttemptDetailLoading());

      Attempt? attempt = await GetAttemptDetail(id, _quizRepository).call();

      if (attempt != null) {
        emit(AttemptDetailCompleted(attempt));
      } else {
        emit(const AttemptDetailError('No data available'));
      }
    } catch (e) {
      emit(AttemptDetailError(e.toString()));
    }
  }
}