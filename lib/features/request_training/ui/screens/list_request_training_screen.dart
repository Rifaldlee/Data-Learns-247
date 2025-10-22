import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/features/request_training/cubit/request_training_list_cubit.dart';
import 'package:data_learns_247/features/request_training/ui/widgets/item/request_training_item.dart';
import 'package:data_learns_247/shared_ui/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RequestTrainingListScreen extends StatefulWidget{
  const RequestTrainingListScreen ({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RequestTrainingListState();
  }
}

class _RequestTrainingListState extends State<RequestTrainingListScreen> {

  @override
  void initState() {
    super.initState();
    context.read<RequestTrainingListCubit>().fetchRequestTrainingList();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: kWhiteColor,
        appBar: const CustomAppBar(
          showBackButton: false,
          title: 'Pengajuan Pelatihan',
        ),
        body: ListView(
          children: [
            listRequestTrainings()
          ],
        ),
      ),
    );
  }

  Widget listRequestTrainings() {
    return BlocBuilder<RequestTrainingListCubit, RequestTrainingListState>(
      builder: (context, state) {
        if (state is RequestTrainingListCompleted) {
          return Column(
            children: state.requestTrainingList.asMap().entries.map(
              (entry) {
                final listRequestTraining = entry.value;
                return RequestTrainingItem(
                  requestTrainingList: listRequestTraining,
                  onTap: () {
                    context.goNamed(
                      RouteConstants.detailTrainingRequest,
                      queryParameters: {
                        'requestTrainingId': listRequestTraining.id.toString(),
                      }
                    );
                  },
                );
              }
            ).toList(),
          );
        } else if (state is RequestTrainingListError) {
          print(" GALAT : ${state.message}");
        }
        return const SizedBox.shrink();
      }
    );
  }
}