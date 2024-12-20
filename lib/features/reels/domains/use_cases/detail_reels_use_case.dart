import 'package:data_learns_247/core/repository/reels_repository.dart';
import 'package:data_learns_247/features/reels/data/models/detail_reels_model.dart';

class GetDetailReels {
  final String _id;
  final ReelsRepository _reelsRepository;

  GetDetailReels(this._id, this._reelsRepository);

  Future<DetailReels?> call() async {
    return await _reelsRepository.getDetailReels(_id);
  }
}