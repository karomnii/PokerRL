import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:frontend/app/game/game.binding.dart';
import 'package:frontend/app/game/game.view.dart';
import 'package:frontend/app/home/home.binding.dart';
import 'package:frontend/app/home/home.view.dart';
import 'package:frontend/theme/theme.dart';
import 'package:get/get.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Router Demo',
      theme: ThemeData(
        extensions: const <ThemeExtension<dynamic>>[
          MyTheme(
            backgroundImageAsset: "background.png",
            appBarColor: Color.fromARGB(255, 5, 19, 33),
            appBarTextColor: Color.fromARGB(255, 255, 242, 242),
          ),
        ],
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const HomePageView(),
          binding: HomePageBinding(),
        ),
        GetPage(
          name: '/game',
          page: () => const GamePageView(),
          binding: GamePageBinding(),
        ),
      ],
    );
  }
}
