part of 'certificate_cubit.dart';

abstract class CertificateState extends Equatable {
  const CertificateState();

  @override
  List<Object> get props => [];
}

class CertificateInitial extends CertificateState {}

class CertificateLoading extends CertificateState {}

class CertificateCompleted extends CertificateState {
  final List<Certificates> certificates;

  const CertificateCompleted(this.certificates);

  @override
  List<Object> get props => [certificates];
}

class CertificateError extends CertificateState {
  final String message;

  const CertificateError(this.message);

  @override
  List<Object> get props => [message];
}
