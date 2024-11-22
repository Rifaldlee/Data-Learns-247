import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/authentication_repository.dart';
import 'package:data_learns_247/core/repository/implementation/authentication_repository_impl.dart';
import 'package:data_learns_247/core/tools/shared_pref_util.dart';
import 'package:data_learns_247/features/authentication/data/models/user_model.dart';
import 'package:data_learns_247/features/authentication/domains/use_cases/user_use_case.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final AuthenticationRepository _authRepo = AuthenticationRepositoryImpl();

  UserCubit() : super(UserInitial());

  void getUserData() async {
    try {
      emit(UserLoading());

      User? userData = await GetUserData(_authRepo).call(SharedPrefUtil.getUserId());

      if(userData != null){
        emit(UserCompleted(userData));
      } else {
        emit(const UserError("User profile is null"));
      }
    } catch(e) {
      emit(UserError(e.toString()));
    }
  }
}
