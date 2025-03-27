import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:frontend/app/game/game.binding.dart';
import 'package:frontend/app/game/game.view.dart';
import 'package:frontend/app/home/home.binding.dart';
import 'package:frontend/app/home/home.view.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Set the initial route and define available routes
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
