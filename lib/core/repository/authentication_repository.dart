import 'package:data_learns_247/features/authentication/data/dto/login_request_payload.dart';
import 'package:data_learns_247/features/authentication/data/dto/register_request_payload.dart';
import 'package:data_learns_247/features/authentication/data/response/login_response.dart';
import 'package:data_learns_247/features/authentication/data/response/register_response.dart';
import 'package:data_learns_247/features/authentication/data/models/user_model.dart';

abstract class AuthenticationRepository {
  Future<LoginResponse?> login(LoginRequestPayload data);
  Future<RegisterResponse?> register(RegisterRequestPayload data);
  Future<User?> getUserProfileData(String id);
}