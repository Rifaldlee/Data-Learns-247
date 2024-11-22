import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/authentication_repository.dart';
import 'package:data_learns_247/core/repository/implementation/authentication_repository_impl.dart';
import 'package:data_learns_247/features/authentication/data/dto/register_request_payload.dart';
import 'package:data_learns_247/features/authentication/data/response/register_response.dart';
import 'package:data_learns_247/features/authentication/domains/use_cases/register_use_case.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthenticationRepository _authRepo = AuthenticationRepositoryImpl();

  RegisterCubit() : super(RegisterInitial());

  void register(RegisterRequestPayload data) async {
    try{
      emit(RegisterLoading());
      RegisterResponse? response = await RegisterUseCase(_authRepo).call(data);

      if(response != null){
        // if (response.code == 406) {
        //   emit(RegisterFailed(response.message ?? 'Register Error'));
        //   return;
        // }
        emit(RegisterCompleted(response));
      } else {
        emit(const RegisterError("Register response is null"));
      }
    } catch(e){
      emit(RegisterError(e.toString()));
    }
  }
}
