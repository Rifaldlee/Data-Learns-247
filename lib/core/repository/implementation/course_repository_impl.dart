import 'package:data_learns_247/core/provider//api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/provider/query_parameter.dart';
import 'package:data_learns_247/core/repository/course_repository.dart';
import 'package:data_learns_247/features/course/data/models/detail_course_model.dart';
import 'package:data_learns_247/features/course/data/models/my_courses_list_model.dart';
import 'package:data_learns_247/features/course/data/response/course_response.dart';
import 'package:data_learns_247/features/course/data/models/list_courses_model.dart';

class CourseRepositoryImpl implements CourseRepository {

  @override
  Future<List<ListCourses>?> getListCourses() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.listCourses,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => ListCourses.fromJson(e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MyCoursesList>?>getMyCoursesList() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.myCourses,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => MyCoursesList.fromJson(e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Course?> getDetailCourse(String id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.detailCourse,
        queryParam: QP.detailCourseQP(id: id),
        useBearer: true
      );

      return NetworkHelper.filterResponse(
        callBack: (json) => Course.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CourseResponse> enrollCourse(int id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        baseUrl: API.publicBaseAPI,
        endpoint: API.enrollCourse,
        useBearer: true,
        body: {'id': id}
      );

      return NetworkHelper.filterResponse(
        callBack: (json) => CourseResponse.fromJson(json),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}