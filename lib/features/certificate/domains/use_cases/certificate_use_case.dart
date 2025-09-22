import 'package:data_learns_247/core/repository/certificate_repository.dart';
import 'package:data_learns_247/features/certificate/data/models/certificate_model.dart';

class GetListCertificates {
  final CertificateRepository _certificateRepository;

  GetListCertificates(this._certificateRepository);

  Future<List<Certificates>?> call() async {
    return await _certificateRepository.getListCertificates();
  }
}