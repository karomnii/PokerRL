// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:frontend/app/home/game/game.binding.dart';
import 'package:frontend/app/home/game/game.view.dart';
import 'package:frontend/app/home/home.binding.dart';
import 'package:frontend/app/home/home.view.dart';
import 'package:frontend/app/home/auth/login/login.binding.dart';
import 'package:frontend/app/home/auth/login/login.view.dart';
import 'package:frontend/app/home/shop/shop.binding.dart';
import 'package:frontend/app/home/shop/shop.view.dart';
import 'package:frontend/theme/theme.dart';
import 'package:get/get.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Router Demo',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      getPages: [
        GetPage(
            name: '/',
            page: () => const HomePageView(),
            binding: HomePageBinding(),
            children: [
              GetPage(
                name: '/game',
                page: () => const GamePageView(),
                binding: GamePageBinding(),
              ),
              GetPage(
                name: '/shop',
                page: () => const ShopPageView(),
                binding: ShopPageBinding(),
              ),
              GetPage(
                  name: '/auth',
                  page: () => const LoginView(),
                  binding: LoginPageBinding(),
                  children: [
                    GetPage(
                      name: '/login',
                      page: () => const LoginView(),
                      binding: LoginPageBinding(),
                    ),
                  ]),
            ]),
      ],
      navigatorObservers: [
        GetObserver(),
      ],
    );
  }
}
