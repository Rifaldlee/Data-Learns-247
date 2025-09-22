import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/implementation/reels_repository_impl.dart';
import 'package:data_learns_247/core/repository/reels_repository.dart';
import 'package:data_learns_247/features/reels/data/models/detail_reels_model.dart';
import 'package:data_learns_247/features/reels/domains/use_cases/detail_reels_use_case.dart';
import 'package:equatable/equatable.dart';

part 'detail_reels_state.dart';

class DetailReelsCubit extends Cubit<DetailReelsState> {
  final ReelsRepository _reelsRepository = ReelsRepositoryImpl();

  DetailReelsCubit() : super(DetailReelsInitial());

  Future<void> fetchDetailReels(String id) async {
    try {
      emit(DetailReelsLoading());

      List<DetailReels> reelsList = await GetDetailReels(id, _reelsRepository).call();

      if (reelsList.isNotEmpty) {
        emit(DetailReelsCompleted(reelsList));
      } else {
        emit(const DetailReelsError('No data available'));
      }
    } catch (e) {
      emit(DetailReelsError(e.toString()));
    }
  }
}