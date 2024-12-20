import 'package:data_learns_247/features/reels/data/models/detail_reels_model.dart';
import 'package:data_learns_247/features/reels/data/models/list_reels_model.dart';

abstract class ReelsRepository {
  Future<List<ListReels>?> getListReels();
  Future<DetailReels?> getDetailReels(String id);
}