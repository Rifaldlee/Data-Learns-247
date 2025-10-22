import 'package:data_learns_247/core/repository/request_training_repository.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_detail_model.dart';

class GetRequestTrainingDetail {
  final String _id;
  final RequestTrainingRepository _requestTrainingRepository;

  GetRequestTrainingDetail(this._id, this._requestTrainingRepository);

  Future<RequestTrainingDetail?> call() async {
    return await _requestTrainingRepository.getRequestTrainingDetail(_id);
  }
}