import 'package:flutter/material.dart';
import 'package:learn_quran/ui/screens/chat/chat_screen.dart';
import 'package:learn_quran/ui/screens/read/read_screen.dart';
import 'package:learn_quran/ui/screens/splash_screen/splash_screen.dart';
import 'package:learn_quran/util/app_constants.dart';

class MyRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
        case chatScreenRoute:
        return MaterialPageRoute(builder: (_) => const ChatStartScreen());
        case readScreenRoute:
        return MaterialPageRoute(builder: (_) => const ReadScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}