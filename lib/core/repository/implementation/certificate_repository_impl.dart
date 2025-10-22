import 'package:data_learns_247/core/provider/api.dart';
import 'package:data_learns_247/core/provider/network_helper.dart';
import 'package:data_learns_247/core/provider/network_service.dart';
import 'package:data_learns_247/core/repository/certificate_repository.dart';
import 'package:data_learns_247/features/certificate/data/models/certificate_model.dart';

class CertificateRepositoryImpl extends CertificateRepository {
  @override
  Future<List<Certificates>?> getListCertificates() async {
    try {
      final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        baseUrl: API.publicBaseAPI,
        endpoint: API.certificate,
        useBearer: true
      );
      return NetworkHelper.filterResponse(
        callBack: (json) => (json as List)
          .map((e) => Certificates.fromJson(e as Map<String, dynamic>))
          .toList(),
        response: response
      );
    } catch (e){
      rethrow;
    }
  }
}