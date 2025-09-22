import 'package:data_learns_247/core/repository/reels_repository.dart';
import 'package:data_learns_247/features/reels/data/dto/analytic_reels_payload.dart';
import 'package:data_learns_247/features/reels/data/response/analytic_response.dart';

class AnalyticUseCase {
  final ReelsRepository _reelsRepository;

  AnalyticUseCase(this._reelsRepository);

  Future<AnalyticResponse?> call(AnalyticReelsPayload data) async {
    return await _reelsRepository.postAnalyticReels(data);
  }
}