part of 'course_sections_cubit.dart';

abstract class CourseSectionsState extends Equatable {
  const CourseSectionsState();

  @override
  List<Object?> get props => [];
}

class CourseSectionsInitial extends CourseSectionsState {}

class CourseSectionsCompleted extends CourseSectionsState {
  final List<Sections> sections;

  const CourseSectionsCompleted(this.sections);

  @override
  List<Object?> get props => [sections];
}
