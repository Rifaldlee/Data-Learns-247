import 'package:data_learns_247/features/request_training/data/models/request_training_detail_model.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_list.dart';

abstract class RequestTrainingRepository {
  Future<List<RequestTrainingList>?> getRequestTrainingList();
  Future<RequestTrainingDetail?> getRequestTrainingDetail(String id);
}