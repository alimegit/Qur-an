import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_quran/util/app_colors.dart';
import 'package:learn_quran/util/app_images.dart';

class AppMainAppbar extends StatelessWidget {
  const AppMainAppbar({super.key, required this.text, required this.onBack});

  final String text;
  final bool onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 50.h, 16.w, 8.h),
      child: Container(
        height: 55.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: onBack,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w),
                child: IconButton(
                  icon: SvgPicture.asset(AppImages.icBack),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: AppColors.textColor,
                fontWeight: FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            // Placeholder for alignment
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
