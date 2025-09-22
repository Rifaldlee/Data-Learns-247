import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:data_learns_247/core/repository/implementation/lesson_repository_impl.dart';
import 'package:data_learns_247/core/repository/lesson_repository.dart';
import 'package:data_learns_247/features/course/data/response/course_response.dart';
import 'package:data_learns_247/features/lesson/domains/finish_lesson.dart';

part 'finish_lesson_state.dart';

class FinishLessonCubit extends Cubit<FinishLessonState> {
  final LessonRepository _lessonRepository = LessonRepositoryImpl();

  FinishLessonCubit() : super(FinishLessonInitial());

  void finishLesson(String id) async {
    try {
      emit(FinishLessonLoading());

      CourseResponse? courseResponse = await FinishLesson(_lessonRepository, id.toInt()).call();

      if (courseResponse != null) {
        emit(FinishLessonCompleted (courseResponse));
        print('FinishLessonCompleted');
      } else {
        emit(const FinishLessonError('Failed'));
        print('FinishLessonError');
      }
    } catch (e) {
      emit(FinishLessonError(e.toString()));
      print(e.toString());
    }
  }
}
