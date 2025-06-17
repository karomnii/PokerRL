import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:frontend/app/home/home.controller.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/widgets/app_bar/app_bar.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_row.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

/// A refreshed home page with a hero section, a carousel of featured games,
/// quick links, and reactive user stats.
class HomePageView extends GetView<HomePageController> {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loggedIn = AuthService.to.isLoggedIn;

    return ThemedScaffold(
      // ──────────────────────────────────────────────────────────────────────
      //  Top App Bar
      // ──────────────────────────────────────────────────────────────────────
      appBar: ThemedAppBar(
        title: 'Home Page',
        actions: [
          AppBarIcon(
            icon: Icons.casino,
            tooltipText: 'Play',
            onPressed: () => Get.toNamed('/games', preventDuplicates: false),
          ),
          AppBarIcon(
            icon: Icons.store,
            tooltipText: 'Shop',
            onPressed: () => Get.toNamed('/shop', preventDuplicates: false),
          ),
          AppBarIcon(
            icon: Icons.emoji_events,
            tooltipText: 'Leaderboard',
            onPressed: () =>
                Get.toNamed('/leaderboard', preventDuplicates: false),
          ),
          _AccountMenu(),
        ],
      ),

      // ──────────────────────────────────────────────────────────────────────
      //  Body
      // ──────────────────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Hero Section ──────────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Column(
                    children: [
                      Text(
                        'Poker AI',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Experience next‑gen poker gaming powered by AI',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Hero(
                        tag: 'dices-image',
                        child: Image.asset(
                          'images/banner.png',
                          height: 400,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () =>
                            Get.toNamed('/games', preventDuplicates: false),
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Play Now'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          textStyle: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Featured Games Carousel ───────────────────────────────
                CarouselSlider(
                  items: const [
                    _GameBanner(
                      image: 'images/fun.png',
                      title: 'Play with friends!',
                    ),
                    _GameBanner(
                      image: 'images/ai.png',
                      title: 'Face various AI models!',
                    ),
                    _GameBanner(
                      image: 'images/friends.png',
                      title: 'Have fun!',
                    ),
                  ],
                  options: CarouselOptions(
                    height: 480,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                  ),
                ),
                const SizedBox(height: 32),

                // ── Quick Links ────────────────────────────────────────────
                PageRow(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _QuickLink(
                      icon: Icons.store,
                      label: 'Shop',
                      route: '/shop',
                    ),
                    _QuickLink(
                      icon: Icons.leaderboard,
                      label: 'Rankings',
                      route: '/leaderboard',
                    ),
                    if (!loggedIn)
                      _QuickLink(
                        icon: Icons.person,
                        label: 'Sign In',
                        route: '/auth/',
                      )
                    else
                      _QuickLink(
                        icon: Icons.person,
                        label: 'Profile',
                        route: '/profile/',
                      ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
//  Account Popup Menu (extracted for brevity)
// ────────────────────────────────────────────────────────────────────────────
class _AccountMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loggedIn = AuthService.to.isLoggedIn;
    return PopupMenuButton<String>(
      icon: Tooltip(
        message: 'Account',
        child: const Icon(
          Icons.person,
          size: 36.0,
        ),
      ),
      onSelected: (value) {
        switch (value) {
          case 'profile':
            Get.toNamed('/profile/');
            break;
          case 'logout':
            AuthService.to.logout();
            Get.offAllNamed('/');
            break;
          case 'login':
            Get.toNamed('/auth/');
            break;
          case 'register':
            Get.toNamed('/auth/register');
            break;
        }
      },
      itemBuilder: (context) {
        return loggedIn
            ? const [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('Profile', style: TextStyle(color: Colors.white)),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Text('Logout', style: TextStyle(color: Colors.white)),
                ),
              ]
            : const [
                PopupMenuItem(
                  value: 'login',
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                ),
                PopupMenuItem(
                  value: 'register',
                  child:
                      Text('Register', style: TextStyle(color: Colors.white)),
                ),
              ];
      },
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
//  Game Banner Widget for Carousel
// ────────────────────────────────────────────────────────────────────────────
class _GameBanner extends StatelessWidget {
  final String image;
  final String title;

  const _GameBanner({
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              image,
              fit: BoxFit.cover,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
//  Quick Link Button Widget
// ────────────────────────────────────────────────────────────────────────────
class _QuickLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final String route;

  const _QuickLink({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FilledButton.icon(
        onPressed: () => Get.toNamed(route, preventDuplicates: false),
        icon: Icon(icon),
        label: Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
