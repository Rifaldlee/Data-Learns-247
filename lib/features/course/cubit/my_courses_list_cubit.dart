import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/core/repository/implementation/course_repository_impl.dart';
import 'package:data_learns_247/features/course/data/models/my_courses_list_model.dart';
import 'package:data_learns_247/features/course/domains/use_cases/my_courses_list_use_case.dart';

part 'my_courses_list_state.dart';

class MyCoursesListCubit extends Cubit<MyCoursesListState> {
  final CourseRepository _courseRepository = CourseRepositoryImpl();

  MyCoursesListCubit() : super(MyCoursesListInitial());

  Future<void> fetchMyCoursesList() async {
    try {
      emit(MyCoursesListLoading());

      List<MyCoursesList>? myCoursesList = await GetMyCoursesList(_courseRepository).call();

      if (myCoursesList!.isEmpty) {
        emit(const MyCoursesListError('No data available'));
      } else {
        emit(MyCoursesListCompleted(myCoursesList));
      }
    } catch (e){
      emit(MyCoursesListError(e.toString()));
    }
  }
}
