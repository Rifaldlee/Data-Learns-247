import 'package:data_learns_247/features/reels/data/dto/analytic_reels_payload.dart';
import 'package:data_learns_247/features/reels/data/models/detail_reels_model.dart';
import 'package:data_learns_247/features/reels/data/models/list_reels_model.dart';
import 'package:data_learns_247/features/reels/data/response/analytic_response.dart';

abstract class ReelsRepository {
  Future<List<ListReels>?> getListReels();
  Future<List<DetailReels>> getDetailReels(String id);
  Future<AnalyticResponse?> postAnalyticReels(AnalyticReelsPayload data);
}