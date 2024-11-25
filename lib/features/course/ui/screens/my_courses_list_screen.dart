import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/course/cubit/my_courses_list_cubit.dart';
import 'package:data_learns_247/features/course/ui/widgets/item/my_course_item.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MyCoursesListScreen extends StatefulWidget {
  const MyCoursesListScreen({super.key});

  @override
  State<MyCoursesListScreen> createState() {
    return _MyCoursesListScreenState();
  }
}

class _MyCoursesListScreenState extends State<MyCoursesListScreen> {

  @override
  void initState() {
    super.initState();
    context.read<MyCoursesListCubit>().fetchMyCoursesList();
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        message: message,
        onClose: () {
          Navigator.of(context).pop();
          context.read<MyCoursesListCubit>().fetchMyCoursesList();
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
            myCoursesList()
          ],
        ),
      ),
    );
  }

  Widget myCoursesList() {
    return BlocBuilder<MyCoursesListCubit, MyCoursesListState>(
      builder: (context, state) {
        if (state is MyCoursesListLoading) {
        }
        if (state is MyCoursesListCompleted) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children:  state.myCoursesList.asMap().entries.map((entry) {
                  final myListCourses = entry.value;
                  return Column(
                    children: [
                      MyCourseItem(
                        myCoursesList: myListCourses,
                        onTap: () {
                          context.pushNamed(
                            RouteConstants.listLessons,
                            pathParameters: {
                              'id': myListCourses.id?.toString() ?? '0'
                            }
                          );
                        },
                      ),
                      if (entry.key != state.myCoursesList.length - 1)
                        Container(
                          width: double.infinity,
                          height: 0.8,
                          color: Colors.grey.withOpacity(0.4),
                        )
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        }
        if (state is MyCoursesListError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showErrorDialog(state.message);
          });
        }
        return const SizedBox.shrink();
      }
    );
  }
}