import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:data_learns_247/core/repository/implementation/reels_repository_impl.dart';
import 'package:data_learns_247/core/repository/reels_repository.dart';
import 'package:data_learns_247/features/reels/data/dto/analytic_reels_payload.dart';
import 'package:data_learns_247/features/reels/data/response/analytic_response.dart';
import 'package:data_learns_247/features/reels/domains/use_cases/analytic_reels_use_case.dart';

part 'analytic_reels_state.dart';

class AnalyticReelsCubit extends Cubit<AnalyticReelsState> {
  final ReelsRepository _reelsRepository = ReelsRepositoryImpl();

  AnalyticReelsCubit() : super(AnalyticReelsInitial());

  void postAnalyticReels(AnalyticReelsPayload data) async {
    try{
     emit(AnalyticReelsLoading());
     AnalyticResponse? response = await AnalyticUseCase(_reelsRepository).call(data);

     if(response != null) {
       emit(AnalyticReelsCompleted(response));
     } else {
       emit(const AnalyticReelsError("Analytic data is null"));
     }
    } catch (e) {
      emit(AnalyticReelsError(e.toString()));
    }
  }
}