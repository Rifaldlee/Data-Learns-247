import 'package:data_learns_247/core/repository/authentication_repository.dart';
import 'package:data_learns_247/features/authentication/data/dto/register_request_payload.dart';
import 'package:data_learns_247/features/authentication/data/response/register_response.dart';

class RegisterUseCase {
  final AuthenticationRepository _authenticationRepository;

  RegisterUseCase(this._authenticationRepository);

  Future<RegisterResponse?> call(RegisterRequestPayload data) async {
    return await _authenticationRepository.register(data);
  }
}