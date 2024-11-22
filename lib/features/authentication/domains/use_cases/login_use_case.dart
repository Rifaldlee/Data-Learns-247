import 'package:nb_utils/nb_utils.dart';
import 'package:data_learns_247/core/repository/authentication_repository.dart';
import 'package:data_learns_247/core/tools/shared_pref_util.dart';
import 'package:data_learns_247/features/authentication/data/dto/login_request_payload.dart';
import 'package:data_learns_247/features/authentication/data/response/login_response.dart';

class LoginUseCase {
  final AuthenticationRepository _authenticationRepository;

  LoginUseCase(this._authenticationRepository);

  Future<LoginResponse?> call(LoginRequestPayload data) async {
    LoginResponse? response = await _authenticationRepository.login(data);

    if(response != null){
      if(response.success!){
        Map<String, dynamic>? decodedToken = JwtDecoder.decode(response.data!.jwt!);
        SharedPrefUtil.storeJwtToken(response.data!.jwt!);
        SharedPrefUtil.storeEmail(decodedToken?["email"]);
        SharedPrefUtil.storeUserId(decodedToken?["id"]);
      }
    }
    return response;
  }
}