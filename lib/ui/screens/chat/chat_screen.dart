import 'dart:async';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_quran/cubit/audio_cubit.dart';
import 'package:learn_quran/cubit/audio_state.dart';
import 'package:learn_quran/services/storage_repository.dart';
import 'package:learn_quran/ui/common_widgets/app_main_appBar.dart';
import 'package:learn_quran/ui/screens/chat/youtube_player_screen.dart';
import 'package:learn_quran/util/app_colors.dart';
import 'package:learn_quran/util/app_constants.dart';
import 'package:learn_quran/util/app_images.dart';

class ChatStartScreen extends StatefulWidget {
  const ChatStartScreen({super.key});

  @override
  State<ChatStartScreen> createState() => _ChatStartScreenState();
}

class _ChatStartScreenState extends State<ChatStartScreen> {
  List<String> audioPaths = [];
  List<PlayerController> playerController = [];
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        audioPaths = StorageRepository.getList('audioPaths');
        playerController = audioPaths.map((_) => PlayerController()).toList();
        for (int i = 0; i < audioPaths.length; i++) {
          playerController[i].preparePlayer(path: audioPaths[i]);
        }
      });
    });
  }

  @override
  void dispose() {
    for (final controller in playerController) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 31, 20),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const YoutubePlayerScreen(),
                                ),
                              );
                            },
                            child: Container(
                              width: 312.w,
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
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              audioPaths.isNotEmpty ? audioPaths.length : 0,
                          itemBuilder: (context, index) {
                            if (audioPaths.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    left: 40, bottom: 8, right: 16),
                                child: Container(
                                  height: 82.h,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.cF5F7F9,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        decoration: const BoxDecoration(
                                            color: AppColors.c4683FA,
                                            shape: BoxShape.circle),
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              isPlaying = !isPlaying;
                                            });
                                            isPlaying?playerController[index]
                                                .startPlayer():playerController[index]
                                                .stopPlayer();
                                          },
                                          icon: Icon(
                                            !isPlaying
                                                ? Icons.play_arrow
                                                : Icons.stop,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      AudioFileWaveforms(
                                        size: Size(200.w, 40.h),
                                        playerController:
                                            playerController[index],
                                        enableSeekGesture: true,
                                        waveformType: WaveformType.fitWidth,
                                        playerWaveStyle: const PlayerWaveStyle(
                                          fixedWaveColor: AppColors.cBAC2E2,
                                          liveWaveColor: AppColors.c4683FA,
                                          waveCap: StrokeCap.round,
                                          spacing: 6.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          },
                        ),
                      ],
                    ),
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
                                padding:
                                    EdgeInsets.only(right: 16.w, left: 8.w),
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
      },
    );
  }
}
