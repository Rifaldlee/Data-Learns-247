import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/greeting_repository.dart';
import 'package:data_learns_247/core/repository/implementation/greeting_repository_impl.dart';
import 'package:data_learns_247/features/greeting/domains/use_cases/greeting_use_case.dart';
import 'package:data_learns_247/features/greeting/greeting_model.dart';
import 'package:equatable/equatable.dart';

part 'greeting_state.dart';

class GreetingCubit extends Cubit<GreetingState> {
  final GreetingRepository _greetingRepository = GreetingRepositoryImpl();

  GreetingCubit() : super(GreetingInitial());

  Future<void> fetchGreeting() async {
    try {
      emit(GreetingLoading());

      Greeting? greeting = await GetGreeting(_greetingRepository).call();

      if (greeting != null) {
        emit(GreetingComplete(greeting));
      } else {
        emit(const GreetingError('Hello'));
      }
    } catch (e) {
      emit(GreetingError(e.toString()));
    }
  }
}
