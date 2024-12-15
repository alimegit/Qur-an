import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:learn_quran/cubit/audio_cubit.dart';
import 'package:learn_quran/ui/router.dart';
import 'package:learn_quran/util/app_colors.dart';
import 'package:learn_quran/util/app_constants.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AudioCubit>(
          create: (_) => AudioCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
              child: child!,
            );
          },
          title: "Learn Qur'an",
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldColor,
            fontFamily: "Golos",
          ),
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          // Sets navigator key
          onGenerateRoute: MyRouter.generateRoute,
          initialRoute: splashRoute,
        ),
      ),
    );
  }
}
