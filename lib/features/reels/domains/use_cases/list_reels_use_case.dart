import 'package:data_learns_247/core/repository/reels_repository.dart';
import 'package:data_learns_247/features/reels/data/models/list_reels_model.dart';

class GetListReels {
  final ReelsRepository _reelsRepository;

  GetListReels(this._reelsRepository);

  Future<List<ListReels>?> call() async {
    return await _reelsRepository.getListReels();
  }
}