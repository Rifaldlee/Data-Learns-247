import 'package:bloc/bloc.dart';
import 'package:data_learns_247/core/repository/certificate_repository.dart';
import 'package:data_learns_247/core/repository/implementation/certificate_repository_impl.dart';
import 'package:data_learns_247/features/certificate/data/models/certificate_model.dart';
import 'package:data_learns_247/features/certificate/domains/use_cases/certificate_use_case.dart';
import 'package:equatable/equatable.dart';

part 'certificate_state.dart';

class CertificateCubit extends Cubit<CertificateState> {
  final CertificateRepository _certificateRepository = CertificateRepositoryImpl();

  CertificateCubit() : super(CertificateInitial());

  Future<void> fetchListCertificates() async {
    try {
      emit(CertificateLoading());

      List<Certificates>? listCertificates = await GetListCertificates(_certificateRepository).call();

      if (listCertificates != null) {
        emit(CertificateCompleted(listCertificates));
      } else {
        emit(const CertificateError('No data available'));
      }
    } catch (e) {
      emit(CertificateError(e.toString()));
    }
  }
}
