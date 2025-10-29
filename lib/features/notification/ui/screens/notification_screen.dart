import 'package:data_learns_247/core/route/page_cubit.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/utils/error_dialog.dart';
import 'package:data_learns_247/features/notification/cubit/notification_cubit.dart';
import 'package:data_learns_247/features/notification/ui/widgets/notification_item.dart';
import 'package:data_learns_247/shared_ui/screens/empty_screen.dart';
import 'package:data_learns_247/shared_ui/widgets/error_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _NotificationScreenState();
  }
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().fetchNotification();
  }
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: kWhiteColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if(!didPop) {
            context.read<PageCubit>().setPage(0);
            context.pushNamed(
              RouteConstants.mainFrontPage,
            );
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: kWhiteColor,
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<NotificationCubit, NotificationState> (
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const CircularProgressIndicator(color: kGreenColor);
                  } else if (state is NotificationCompleted) {
                    return ListView(
                      children: [
                        Column(
                          children: state.notification.data!.asMap().entries.map(
                            (entry) {
                              final notificationList = entry.value;
                              return NotificationItem(data: notificationList);
                            }
                          ).toList(),
                        )
                      ],
                    );
                  } else if (state is NotificationEmpty) {
                    return const EmptyScreen(
                      title: 'Belum ada informasi terbaru',
                      description: 'Kami akan memberikan anda informasi terupdate'
                    );
                  } else if (state is NotificationError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ErrorDialog.showErrorDialog( context, state.message, () {
                        Navigator.of(context).pop();
                        context.read<NotificationCubit>().fetchNotification();
                      });
                    });
                  }
                  return const SizedBox.shrink();
                }
              ),
            ),
          ),
        )
      ),
    );
  }
}