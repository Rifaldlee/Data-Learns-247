import 'package:data_learns_247/core/repository/request_training_repository.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_list.dart';

class GetRequestTrainingList {
  final RequestTrainingRepository _requestTrainingRepository;

  GetRequestTrainingList(this._requestTrainingRepository);

  Future<List<RequestTrainingList>?> call() async {
    return await _requestTrainingRepository.getRequestTrainingList();
  }
}