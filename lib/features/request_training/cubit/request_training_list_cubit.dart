import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/implementation/request_training_repository_impl.dart';
import 'package:data_learns_247/core/repository/request_training_repository.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_list.dart';
import 'package:data_learns_247/features/request_training/domains/use_cases/request_training_list_use_case.dart';
import 'package:equatable/equatable.dart';

part 'request_training_list_state.dart';

class RequestTrainingListCubit extends Cubit<RequestTrainingListState> {
  final RequestTrainingRepository _requestTrainingRepository = RequestTrainingImpl();

  RequestTrainingListCubit() : super(RequestTrainingListInitial());

  Future<void> fetchRequestTrainingList() async {
    try {
      emit(RequestTrainingListLoading());

      List<RequestTrainingList>? requestTrainingList = await GetRequestTrainingList(_requestTrainingRepository).call();

      if (requestTrainingList == null || requestTrainingList.isEmpty) {
        emit(const RequestTrainingListEmpty());
      } else {
        emit(RequestTrainingListCompleted(requestTrainingList));
      }
    } catch (e) {
      emit(RequestTrainingListError(e.toString()));
    }
  }
}
