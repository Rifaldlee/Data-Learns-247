import 'package:data_learns_247/features/course/ui/widgets/placeholder/list_course_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/course/cubit/list_courses_cubit.dart';
import 'package:data_learns_247/features/course/ui/widgets/item/course_item.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog.dart';

class ListCoursesScreen extends StatefulWidget {
  const ListCoursesScreen({super.key});

  @override
  State<ListCoursesScreen> createState() {
    return _ListCoursesScreen();
  }
}

class _ListCoursesScreen extends State<ListCoursesScreen> {

  @override
  void initState() {
    super.initState();
    context.read<ListCoursesCubit>().fetchListCourses();
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
      message: message,
      onClose: () {
        Navigator.of(context).pop();
        context.read<ListCoursesCubit>().fetchListCourses();
        }
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        body: ListView(
          children: [
            listCourses()
          ],
        ),
      ),
    );
  }

  Widget listCourses() {
    return BlocBuilder<ListCoursesCubit, ListCoursesState>(
      builder: (context, state) {
        if (state is ListCoursesLoading) {
          return const ListCoursePlaceholder();
        }
        if (state is ListCoursesCompleted) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children:  state.listCourses.asMap().entries.map(
                  (entry) {
                    final listCourses = entry.value;
                    return Column(
                      children: [
                        CourseItem(
                          listCourses: listCourses,
                          onTap: () {
                            context.pushNamed(
                              RouteConstants.detailCourse,
                              pathParameters: {
                                'id': listCourses.id?.toString() ?? '0'
                              }
                            );
                          },
                        ),
                        if (entry.key != state.listCourses.length - 1)
                          Container(
                            width: double.infinity,
                            height: 0.8,
                            color: Colors.grey.withOpacity(0.4),
                          )
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          );
        }
        if (state is ListCoursesError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(state.message);
          });
        }
        return const SizedBox.shrink();
      }
    );
  }
}