import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_quran/cubit/audio_cubit.dart';
import 'package:learn_quran/cubit/audio_state.dart';
import 'package:learn_quran/ui/common_widgets/app_main_appBar.dart';
import 'package:learn_quran/util/app_colors.dart';
import 'package:learn_quran/util/app_images.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AudioCubit(),
      child: BlocBuilder<AudioCubit, AudioState>(
        builder: (context, state) {
          return Scaffold(
            body: Column(
              children: [
                const AppMainAppbar(
                  text: "Fotiha surasini qiroat qilish",
                  onBack: true,
                ),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppImages.imgSurahAlFatih,
                          width: 343.w, height: 463.h),
                      state is AudioStopped
                          ? Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text("00:59"),
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  height: 100.h,
                                  child: _buildDynamicContent(state, context),
                                ),
                                SizedBox(height: 18.h),
                                GestureDetector(
                                  onTap: () {
                                    if (state is AudioRecording) {
                                      context
                                          .read<AudioCubit>()
                                          .stopRecording();
                                    } else if (state is AudioStopped) {
                                      context
                                          .read<AudioCubit>()
                                          .playRecording();
                                    } else {
                                      context
                                          .read<AudioCubit>()
                                          .startRecording();
                                    }
                                  },
                                  child: Container(
                                    height: 88,
                                    width: 88,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.learnMainColor,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        state is AudioRecording
                                            ? AppImages.icStop
                                            : AppImages.icMicrophone,
                                        width: 13.5.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: state is AudioStopped
                ? Container(
              decoration: const BoxDecoration(
                color: AppColors.learnWhite,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(33),
                  topLeft: Radius.circular(33),
                ),
              ),
              child: Padding(
                padding:  EdgeInsets.fromLTRB(8.w, 4.h, 8.w, 33.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<AudioCubit>().playRecording();
                      },
                      child: Container(
                        height: 64,
                        width: 64,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.scaffoldColor,
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            AppImages.icPlay,
                            width: 24.w,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Container(
                        width: 223.w,
                        height: 64.h,
                        decoration: BoxDecoration(
                          color: AppColors.learnMainColor,
                          borderRadius: BorderRadius.circular(64.r)
                        ),
                        child: const Center(
                          child: Text("Yuborish",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: AppColors.learnWhite)),
                        ),
                      ),
                    ),
                    Container(
                      height: 64,
                      width: 64,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.scaffoldColor,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppImages.icDelete,
                          width: 24.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                : const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  Widget _buildDynamicContent(AudioState state, BuildContext context) {
    if (state is AudioRecording) {
      return Center(
        child: Text(
          "00:23",
          style: TextStyle(
            fontSize: 18.sp,
            color: AppColors.textColor,
          ),
        ),
      );
    } else if (state is AudioStopped) {
      return GestureDetector(
        onTap: () {
          context.read<AudioCubit>().playRecording();
        },
        child: Container(
          height: 50.h,
          width: 150.w,
          color: AppColors.c939EC5.withOpacity(0.5),
          child: Center(
            child: Text(
              "Play Audio",
              style: TextStyle(
                fontSize: 16.sp,
                color: AppColors.textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    } else {
      return Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(
              "Qiroatni yozib yuborish uchun quyidagi tugmani 1 marta bosing",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textColor,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 8.h),
            child: Text(
              "Qiroatni 10 dan 120 sekundgacha yuboring",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.c939EC5,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      );
    }
  }
}
