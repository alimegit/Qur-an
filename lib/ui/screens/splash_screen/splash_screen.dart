
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_quran/util/app_colors.dart';
import 'package:learn_quran/util/app_constants.dart';
import 'package:learn_quran/util/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, chatScreenRoute);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.learnMainColor,
      body: Stack(
        children: [
          Center(
            child: Text(
              "الفاتحة",
              style: TextStyle(
                color: AppColors.learnWhite,
                fontSize: 32.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.learnWhite,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: SvgPicture.asset(AppImages.icMicrophone),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
