import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/theme/theme.dart';
import 'package:data_learns_247/features/certificate/cubit/certificate_cubit.dart';
import 'package:data_learns_247/features/certificate/ui/placeholder/certificate_screen_placeholder.dart';
import 'package:data_learns_247/shared_ui/screens/empty_screen.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';

class CertificateScreen extends StatefulWidget {
  const CertificateScreen({super.key});

  @override
  State<CertificateScreen> createState() => _CertificateState();
}

class _CertificateState extends State<CertificateScreen> {

  @override
  void initState() {
    context.read<CertificateCubit>().fetchListCertificates();
    super.initState();
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.manageExternalStorage.isGranted) return true;

      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      final status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  Future<void> downloadPdf(String url, String fileName) async {
    final hasPermission = await requestStoragePermission();
    if (!hasPermission) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin penyimpanan ditolak')),
      );
      return;
    }

    try {
      Directory directory;

      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath = '${directory.path}/$fileName.pdf';

      final dio = Dio();
      await dio.download(url, filePath);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sertifikat berhasil disimpan')),
      );
    } catch (e) {
      debugPrint('Download error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunduh sertifikat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        appBar: const CustomAppBar(
          showBackButton: true,
          title: 'Sertifikat anda',
        ),
        backgroundColor: kWhiteColor,
        body: ListView(
          children: [
            listCertificates()
          ],
        )
      ),
    );
  }

  Widget listCertificates() {
    return BlocBuilder<CertificateCubit, CertificateState>(
      builder: (context, state) {
        if (state is CertificateLoading) {
          return const CertificateScreenPlaceholder();
        }
        if (state is CertificateCompleted) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 16
            ),
            child: Column(
              children: state.certificates.asMap().entries.map((entry) {
                final listCertificates = entry.value;
                return SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listCertificates.certificateId.toString(),
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 18,
                          fontWeight: bold,
                        ),
                      ),
                      Stack(
                        children: [
                          Center(
                            child: AspectRatio(
                              aspectRatio: 16/9,
                              child: const PDF().cachedFromUrl(
                                listCertificates.certificateFile.toString(),
                                placeholder: (progress) => const Center(
                                  child: Text('loading')
                                ),
                                errorWidget: (error) => Center(
                                  child: Text(error.toString())
                                ),
                              ),
                            )
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: SafeArea(
                              child: GestureDetector(
                                onTap: () {
                                  final fileUrl = listCertificates.certificateFile.toString();
                                  final fileName = '${listCertificates.certificateId.toString()}_DataLearns'; // atau pakai nama dari model
                                  downloadPdf(fileUrl, fileName);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.download,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              )
                            )
                          ),
                        ]
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }
        if (state is CertificateError) {
          return Container(
            margin: const EdgeInsets.only(top: 96),
            child: const EmptyScreen(
                title: 'Anda belum memiliki sertifikat apapun',
                description: 'Coba untuk menyelsesaikan kelas yang anda ikuti terlebih dahulu'
            ),
          );
        }
        return const SizedBox.shrink();
      }
    );
  }
}