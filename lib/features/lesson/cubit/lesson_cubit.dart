import 'package:data_learns_247/core/repository/lesson_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/implementation/lesson_repository_impl.dart';
import 'package:data_learns_247/features/lesson/data/models/lesson_model.dart';
import 'package:data_learns_247/features/lesson/domains/lesson_use_case.dart';

part 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {
  final LessonRepository _lessonRepository = LessonRepositoryImpl();

  LessonCubit() : super(LessonInitial());

  Future<void> fetchLesson(String id) async {
    try {
      emit(LessonLoading());

      Lesson? lesson = await GetLesson(id, _lessonRepository).call();

      if (lesson != null) {
        emit(LessonCompleted(lesson));
      } else {
        emit(const LessonError('No data available'));
      }
    } catch(e) {
      emit(LessonError(e.toString()));
    }
  }
}
