import 'package:data_learns_247/core/repository/authentication_repository.dart';
import 'package:data_learns_247/features/authentication/data/models/user_model.dart';

class GetUserData {
  final AuthenticationRepository _authenticationRepository;

  GetUserData(this._authenticationRepository);

  Future<User?> call(String id) async {
    return await _authenticationRepository.getUserProfileData(id);
  }
}