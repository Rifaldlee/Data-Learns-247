import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/repository/authentication_repository.dart';
import 'package:data_learns_247/features/authentication/data/dto/login_request_payload.dart';
import 'package:data_learns_247/features/authentication/data/dto/register_request_payload.dart';
import 'package:data_learns_247/features/authentication/data/response/login_response.dart';
import 'package:data_learns_247/features/authentication/data/response/register_response.dart';
import 'package:data_learns_247/features/authentication/data/models/user_model.dart';

class AuthenticationRepositoryImpl extends AuthenticationRepository{

  @override
  Future<LoginResponse?> login(LoginRequestPayload data) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        baseUrl: API.publicBaseAPI,
        endpoint: API.login,
        body: data.toJson()
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => LoginResponse.fromJson(json),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RegisterResponse?> register(RegisterRequestPayload data) async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.post,
        baseUrl: API.publicBaseAPI,
        endpoint: API.register,
        body: data.toJson()
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => RegisterResponse.fromJson(json),
        response: response
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> getUserProfileData(String id) async {
    try {
      final response = await NetworkService.sendRequest(
          requestType: RequestType.get,
          baseUrl: API.publicBaseAPI,
          endpoint: API.user(id),
          useBearer: true
      );
      return NetworkHelper.filterResponse(
          callBack: (json) => User.fromJson(json),
          response: response
      );
    } catch (e) {
      rethrow;
    }
  }
}