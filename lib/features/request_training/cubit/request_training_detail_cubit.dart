import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/implementation/request_training_repository_impl.dart';
import 'package:data_learns_247/core/repository/request_training_repository.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_detail_model.dart';
import 'package:data_learns_247/features/request_training/domains/use_cases/request_training_detail_use_case.dart';
import 'package:equatable/equatable.dart';

part 'request_training_detail_state.dart';

class RequestTrainingDetailCubit extends Cubit<RequestTrainingDetailState> {
  final RequestTrainingRepository _requestTrainingRepository = RequestTrainingImpl();

  RequestTrainingDetailCubit() : super(RequestTrainingDetailInitial());

  Future<void> fetchRequestTrainingDetail(String id) async {
    try {
      emit(RequestTrainingDetailLoading());

      RequestTrainingDetail? requestTrainingDetail = await GetRequestTrainingDetail(id, _requestTrainingRepository).call();

      if (requestTrainingDetail != null) {
        emit(RequestTrainingDetailCompleted(requestTrainingDetail));
      } else {
        emit(const RequestTrainingDetailError('No data available'));
      }
    } catch (e) {
      emit(RequestTrainingDetailError(e.toString()));
    }
  }
}
