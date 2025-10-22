import 'package:flutter/widgets.dart';
import 'package:frontend/api/swagger.models.swagger.dart';
import 'package:frontend/app/home/games/game/game.binding.dart';
import 'package:frontend/app/home/games/game/game.view.dart';
import 'package:frontend/app/home/leaderboard/leaderboard.binding.dart';
import 'package:frontend/app/home/leaderboard/leaderboard.view.dart';
import 'package:frontend/app/home/policy/policy.binding.dart';
import 'package:frontend/app/home/policy/policy.view.dart';
import 'package:frontend/app/home/profile/profile.binding.dart';
import 'package:frontend/app/home/profile/profile.view.dart';
import 'package:get/get.dart';

import '../app/home/home.binding.dart';
import '../app/home/home.view.dart';

import '../app/home/games/games.binding.dart';
import '../app/home/games/games.view.dart';

import '../app/home/shop/shop.binding.dart';
import '../app/home/shop/shop.view.dart';

import '../app/home/auth/auth.binding.dart';
import '../app/home/auth/auth.view.dart';
import '../app/home/auth/login/login.binding.dart';
import '../app/home/auth/login/login.view.dart';
import '../app/home/auth/register/register.binding.dart';
import '../app/home/auth/register/register.view.dart';

import '../services/auth.service.dart';
import '../services/error_service.dart';

/* ───────────────  Auth Guard  ─────────────── */

class AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final bool isPublicRoute =
        route == Routes.home || route?.startsWith(Routes.authPrefix) == true;

    if (!AuthService.to.isLoggedIn && !isPublicRoute) {
      ErrorService.to.showError('Log in to access that page');
      return const RouteSettings(name: Routes.login);
    }
    return null;
  }
}

/* ───────────────  Path constants  ─────────────── */

abstract class Routes {
  static const home = '/';

  // auth subtree
  static const authPrefix = '/auth';
  static const auth = '/auth';
  static const login = '/auth/login';
  static const register = '/auth/register';

  // private pages
  static const games = '/games';
  static const shop = '/shop';
  static const profile = '/profile';
  static const leaderboard = '/leaderboard';
  static const policy = '/policy';
}

/* ───────────────  Page table  ─────────────── */

final List<GetPage<dynamic>> appPages = [
  /* --------  HOME (public)  -------- */
  GetPage(
    name: Routes.home,
    page: () => const HomePageView(),
    binding: HomePageBinding(),
  ),

  /* --------  PRIVATE PAGES  -------- */
  GetPage(
      name: Routes.games,
      page: () => const GamesPageView(),
      binding: GamesPageBinding(),
      middlewares: [
        AuthGuard()
      ],
      children: [
        GetPage(
          name: '/:id',
          page: () => const GamePageView(),
          binding: GamePageBinding(),
          middlewares: [
            AuthGuard(),
          ],
        ),
      ]),
  GetPage(
    name: Routes.shop,
    page: () => const ShopPageView(),
    binding: ShopPageBinding(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.profile,
    page: () => const ProfilePageView(),
    binding: ProfilePageBinding(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.leaderboard,
    page: () => const LeaderboardPageView(),
    binding: LeaderboardPageBinding(),
    middlewares: [AuthGuard()],
  ),
  GetPage(
    name: Routes.policy,
    page: () => PolicyPageView(),
    binding: PolicyPageBinding(),
  ),
  /* --------  AUTH SUB-TREE (public)  -------- */
  GetPage(
    name: Routes.auth,
    page: () => AuthView(),
    binding: AuthPageBinding(),
    children: [
      GetPage(
        name: '/login',
        page: () => const LoginView(),
        binding: LoginPageBinding(),
      ),
      GetPage(
        name: '/register',
        page: () => RegisterView(),
        binding: RegisterPageBinding(),
      ),
    ],
  ),
];
