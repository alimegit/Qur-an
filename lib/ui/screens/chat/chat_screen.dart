import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_quran/ui/common_widgets/app_main_appBar.dart';
import 'package:learn_quran/util/app_colors.dart';
import 'package:learn_quran/util/app_constants.dart';
import 'package:learn_quran/util/app_images.dart';

class ChatStartScreen extends StatelessWidget {
  const ChatStartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const AppMainAppbar(
            text: "Fotiha surasi",
            onBack: false,
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              height: 588.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.learnWhite,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 31, 347),
                    child: Container(
                      width: 312.w,
                      height: 233.h,
                      decoration: BoxDecoration(
                        color: AppColors.scaffoldColor,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppImages.imgDomla),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Fotiha surasida yo‘l qo‘yilishi mumkin bo‘lgan xatolar",
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: const BoxDecoration(
          color: AppColors.learnWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(33),
            topRight: Radius.circular(33),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(4.w, 4.h, 4.w, 16.h),
          child: SizedBox(
            height: 64.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Qiroatni tekshirish...",
                  style: TextStyle(
                    color: AppColors.c939EC5,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(48.r),
                    onTap: () {
                      Navigator.pushNamed(context, readScreenRoute);
                    },
                    child: Container(
                      height: 40.h,
                      margin: EdgeInsets.only(left: 16.w),
                      padding: EdgeInsets.only(left: 16.w),
                      decoration: BoxDecoration(
                        color: AppColors.learnMainColor,
                        borderRadius: BorderRadius.circular(48.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Qiroat qilish",
                            style: TextStyle(
                              color: AppColors.learnWhite,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.sp,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 16.w, left: 8.w),
                            child: SvgPicture.asset(AppImages.icToward),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}