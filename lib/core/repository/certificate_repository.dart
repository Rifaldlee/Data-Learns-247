import 'package:data_learns_247/features/certificate/data/models/certificate_model.dart';

abstract class CertificateRepository {
  Future<List<Certificates>?> getListCertificates();
}