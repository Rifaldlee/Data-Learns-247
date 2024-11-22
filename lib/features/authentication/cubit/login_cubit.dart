import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/authentication_repository.dart';
import 'package:data_learns_247/core/repository/implementation/authentication_repository_impl.dart';
import 'package:data_learns_247/features/authentication/data/dto/login_request_payload.dart';
import 'package:data_learns_247/features/authentication/data/response/login_response.dart';
import 'package:data_learns_247/features/authentication/domains/use_cases/login_use_case.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthenticationRepository _authRepo = AuthenticationRepositoryImpl();

  LoginCubit() : super(LoginInitial());

  void login(LoginRequestPayload data) async {
    try {
      emit(LoginLoading());

      LoginResponse? response = await LoginUseCase(_authRepo).call(data);

      if (response != null) {
        // if (response.data?.errorCode == 48) {
        //   emit(LoginFailed(response.data?.message ?? 'Login Error'));
        //   return;
        // }
        emit(LoginCompleted(response));
      } else {
        emit(const LoginError("Login response is null"));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}

