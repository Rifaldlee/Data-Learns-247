import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:data_learns_247/core/route/route_constant.dart';
import 'package:data_learns_247/core/theme/color.dart';
import 'package:data_learns_247/core/tools/shared_pref_util.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    navigateAfterSplash();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void navigateAfterSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    if (SharedPrefUtil.hasNotificationData()) {
      final notificationData = SharedPrefUtil.getNotificationData();

      await SharedPrefUtil.clearNotificationData();

      if (notificationData != null) {
        if (notificationData['type'] == 'article') {
          context.push('/mainFrontPage/detailArticle/${notificationData['id']}/${notificationData['has_video']}');
        } else if (notificationData['type'] == 'course') {
          context.push('/mainFrontPage/detailCourse/${notificationData['id']}');
        }
        return;
      }
    }

    if (SharedPrefUtil.getJwtToken().isNotEmpty) {
      context.goNamed(RouteConstants.mainFrontPage);
    } else {
      context.goNamed(RouteConstants.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      ),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: kBackgroundColor,
                image: DecorationImage(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage("assets/img/splashscreen_bottom_bit.png")
                )
              ),
            ),
            Container(
              width: 300,
              margin: const EdgeInsets.only(bottom: 100),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  alignment: Alignment.center,
                  image:
                  AssetImage("assets/img/splashscreen_logo_bit.png")
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}