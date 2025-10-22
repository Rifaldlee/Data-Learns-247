import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/request_training/cubit/request_training_detail_cubit.dart';
import 'package:data_learns_247/features/request_training/data/models/request_training_detail_model.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RequestTrainingDetailScreen extends StatefulWidget {
  final String id;

  const RequestTrainingDetailScreen({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return _RequestTrainingDetailState();
  }
}

class _RequestTrainingDetailState extends State<RequestTrainingDetailScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchRequestTrainingData();
    });
  }

  void fetchRequestTrainingData() {
    if (widget.id.isNotEmpty) {
      context.read<RequestTrainingDetailCubit>().fetchRequestTrainingDetail(widget.id);

    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestTrainingDetailCubit, RequestTrainingDetailState>(
      builder: (context, state) {
        if (state is RequestTrainingDetailLoading) {

        } else if (state is RequestTrainingDetailCompleted) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: kWhiteColor,
              statusBarIconBrightness: Brightness.dark
            ),
            child: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (!didPop) {
                  context.pushNamed(
                    RouteConstants.listTrainingRequest
                  );
                }
              },
              child: Scaffold(
                backgroundColor: kWhiteColor,
                appBar: CustomAppBar(
                  title: 'Pengajuan Pelatihan',
                  showBackButton: true,
                  backAction: () {
                    context.pushNamed(
                      RouteConstants.listTrainingRequest
                    );
                  },
                ),
                body: requestTrainingDetail(state.requestTrainingDetail),
              )
            ),
          );
        } else if (state is RequestTrainingDetailError) {
          print("GALAT : ${state.message}");
        }
        return const SizedBox.shrink();
      }
    );
  }

  Widget requestTrainingDetail(RequestTrainingDetail requestTrainingDetail) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            requestTrainingHeading(
              requestTrainingDetail.productName.toString(),
              requestTrainingDetail.status.toString()
            ),
            const SizedBox(height: 12),
            requestInformation(requestTrainingDetail),
            const SizedBox(height: 12),
            trainingInformation(requestTrainingDetail),
            approval(requestTrainingDetail.approvals)
          ],
        ),
      ),
    );
  }

  Widget requestTrainingHeading(String name, String status) {
    Color statusColor = kLightGreyColor;
    if (status == "waiting-approval") {
      statusColor = Colors.orange;
    } else {
      statusColor = kGreenColor;
    }
    return Container(
      padding: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 2,
          )
        )
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 2,
              style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: kBlackColor, fontSize: 20)
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(4)
              ),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: kWhiteColor
              ),
            )
          )
        ],
      ),
    );
  }

  Widget requestInformation(RequestTrainingDetail requestTrainingDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Request Information',
          style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: kBlackColor, fontSize: 18)
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                requestTrainingInformationItem(
                  'Nama Project',
                  ' : ${requestTrainingDetail.namaProject.toString()}'
                ),
                const SizedBox(height: 8),
                requestTrainingInformationItem(
                  'Id Request',
                  ' : ${requestTrainingDetail.id.toString()}'
                ),
                const SizedBox(height: 8),
                requestTrainingInformationItem(
                  'Pengajuan',
                  ' : ${requestTrainingDetail.dateCreated.toString()}'
                ),
                const SizedBox(height: 8),
                requestTrainingInformationItem(
                  'Kontak PIC',
                  ' : ${requestTrainingDetail.kontakPic.toString()}'
                ),
                const SizedBox(height: 8),
                requestTrainingInformationItem(
                  'Nilai Training',
                  ' : ${requestTrainingDetail.nilaiTraining.toString()}'
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget trainingInformation(RequestTrainingDetail requestTrainingDetail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Training Information',
          style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: kBlackColor, fontSize: 18)
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8)
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                requestTrainingInformationItem(
                  'Tanggal Mulai',
                  ' : ${requestTrainingDetail.tanggalMulai.toString()}'
                ),
                const SizedBox(height: 8),
                requestTrainingInformationItem(
                  'Lokasi',
                  ' : ${requestTrainingDetail.tempatPelaksanaan.toString()}'
                ),
                const SizedBox(height: 8),
                requestTrainingInformationItem(
                  'Peserta',
                  ' : ${requestTrainingDetail.pesertaTraining.toString()}'
                ),
                const SizedBox(height: 8),
                requestTrainingInformationItem(
                  'Profil Peserta',
                  ' : ${requestTrainingDetail.profilPeserta.toString()}'
                ),
                const SizedBox(height: 8),
                requestTrainingInformationItem(
                  'Jumlah Peserta',
                  ' : ${requestTrainingDetail.jumlahPeserta.toString()}'
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget requestTrainingInformationItem(String title, String content) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold
            )
          )
        ),
        Expanded(
          flex: 2,
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge
          )
        )
      ],
    );
  }

  Widget approval(List<Approvals>? approvals) {
    // Handle jika approvals null atau empty
    if (approvals == null || approvals.isEmpty) {
      return const Center(
        child: Text('No approval data available'),
      );
    }

    return Stepper(
      controlsBuilder: (BuildContext context, ControlsDetails details) {
        // Hide default buttons (next/back)
        return const SizedBox.shrink();
      },
      steps: _buildApprovalSteps(approvals),
    );
  }

  List<Step> _buildApprovalSteps(List<Approvals> approvals) {
    return approvals.asMap().entries.map((entry) {
      final index = entry.key;
      final approval = entry.value;

      // Tentukan status step berdasarkan approval status
      StepState stepState = StepState.indexed;
      bool isCompleted = false;

      switch (approval.status?.toLowerCase()) {
        case 'approved':
          stepState = StepState.complete;
          isCompleted = true;
          break;
        case 'rejected':
          stepState = StepState.error;
          isCompleted = true;
          break;
        case 'pending':
          stepState = StepState.indexed;
          isCompleted = false;
          break;
        default:
          stepState = StepState.indexed;
          isCompleted = false;
      }

      return Step(
        title: Text(
          approval.name ?? 'Unknown Approver',
          style: TextStyle(
            color: kBlackColor
            // color: _getStatusColor(approval.status),
          ),
        ),
        subtitle: approval.status != null
            ? Text(
          'Status: ${_formatStatus(approval.status!)}',
          style: TextStyle(
            color: _getStatusColor(approval.status),
            fontWeight: FontWeight.w500,
          ),
        )
            : null,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (approval.note?.isNotEmpty ?? false) ...[
              Text(
                'Note:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                approval.note!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ] else
              Text(
                'No note provided',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        state: stepState,
        isActive: _isStepActive(approvals, index),
      );
    }).toList();
  }

  bool _isStepActive(List<Approvals> approvals, int currentIndex) {
    // Step aktif jika semua step sebelumnya completed
    for (int i = 0; i < currentIndex; i++) {
      final status = approvals[i].status?.toLowerCase();
      if (status != 'approved' && status != 'rejected') {
        return false;
      }
    }
    return true;
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formatStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'pending':
        return 'Pending Approval';
      default:
        return status;
    }
  }
}