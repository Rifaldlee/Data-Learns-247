import 'package:data_learns_247/features/greeting/greeting_model.dart';

abstract class GreetingRepository {
  Future<Greeting?> getGreeting();
}