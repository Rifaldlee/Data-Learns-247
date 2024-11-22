import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/provider/query_parameter.dart';
import 'package:data_learns_247/core/repository/lesson_repository.dart';
import 'package:data_learns_247/features/course/data/response/course_response.dart';
import 'package:data_learns_247/features/lesson/data/models/lesson_model.dart';

class LessonRepositoryImpl extends LessonRepository {

  @override
  Future<Lesson?> getLesson(String id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.lesson,
        queryParam: QP.lessonQP(id: id),
        useBearer: true,
        useCookie: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => Lesson.fromJson(json as Map<String, dynamic>),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CourseResponse> finishLesson(int id) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        baseUrl: API.publicBaseAPI,
        endpoint: API.finishLesson,
        useBearer: true,
        useCookie: true,
        body: {'id' : id}
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