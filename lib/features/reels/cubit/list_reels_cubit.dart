import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/implementation/reels_repository_impl.dart';
import 'package:data_learns_247/core/repository/reels_repository.dart';
import 'package:data_learns_247/features/reels/data/models/list_reels_model.dart';
import 'package:data_learns_247/features/reels/domains/use_cases/list_reels_use_case.dart';
import 'package:equatable/equatable.dart';

part 'list_reels_state.dart';

class ListReelsCubit extends Cubit<ListReelsState> {
  final ReelsRepository _reelRepository = ReelsRepositoryImpl();

  ListReelsCubit() : super(ListReelsInitial());

  Future<void> fetchListReels() async {
    try {
      emit(ListReelsLoading());

      List<ListReels>? listReel = await GetListReels(_reelRepository).call();

      if (listReel == null || listReel.isEmpty) {
        emit(const ListReelsEmpty());
      } else {
        emit(ListReelsCompleted(listReel));
      }
    } catch (e) {
      emit(ListReelsError(e.toString()));
    }
  }
}