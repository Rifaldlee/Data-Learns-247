import 'package:data_learns_247/core/repository/greeting_repository.dart';
import 'package:data_learns_247/features/greeting/greeting_model.dart';

class GetGreeting {
  final GreetingRepository _greetingRepository;

  GetGreeting(this._greetingRepository);

  Future<Greeting?> call() async {
    return await _greetingRepository.getGreeting();
  }
}