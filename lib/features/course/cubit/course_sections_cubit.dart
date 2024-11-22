import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'course_sections_state.dart';

class CourseSectionsCubit extends Cubit<CourseSectionsState> {
  CourseSectionsCubit() : super(CourseSectionsInitial());

  void setSections(List<Sections> sections) {
    emit(CourseSectionsCompleted(sections));
  }

  void clearSections() {
    emit(CourseSectionsInitial());
  }
}
