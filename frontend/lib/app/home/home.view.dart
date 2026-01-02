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
            icon: Icons.info_sharp,
            tooltipText: 'Privacy Policy',
            onPressed: () => Get.toNamed('/policy', preventDuplicates: false),
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 820;
            final theme = Theme.of(context);
            final loggedIn = AuthService.to.isLoggedIn;

            Widget carouselCard() {
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CarouselSlider(
                  items: const [
                    _GameBanner(image: 'assets/images/banner.png', title: ''),
                    _GameBanner(
                        image: 'assets/images/fun.png',
                        title: 'Play with friends!'),
                    _GameBanner(
                        image: 'assets/images/ai.png',
                        title: 'Face various AI models!'),
                    _GameBanner(
                        image: 'assets/images/friends.png', title: 'Have fun!'),
                  ],
                  options: CarouselOptions(
                    // NIE ustawiaj height tutaj
                    aspectRatio: isWide ? 16 / 9 : 4 / 5,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    enlargeCenterPage: true,
                    viewportFraction: 0.65,
                  ),
                ),
              );
            }

            Widget actionsCard() {
              var space = 10.0;
              return Column(
                children: [
                  PageCard(
                    padding: 4.0,
                    margin: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () =>
                              Get.toNamed('/games', preventDuplicates: false),
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Play Now'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            textStyle: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: space),

                        // reszta przycisków pod spodem
                        FilledButton.icon(
                          onPressed: () =>
                              Get.toNamed('/shop', preventDuplicates: false),
                          icon: const Icon(Icons.store),
                          label: const Text('Shop'),
                        ),
                        SizedBox(height: space),

                        FilledButton.icon(
                          onPressed: () => Get.toNamed('/leaderboard',
                              preventDuplicates: false),
                          icon: const Icon(Icons.leaderboard),
                          label: const Text('Rankings'),
                        ),
                        SizedBox(height: space),

                        FilledButton.icon(
                          onPressed: () => Get.toNamed(
                            loggedIn ? '/profile/' : '/auth/',
                            preventDuplicates: false,
                          ),
                          icon: const Icon(Icons.person),
                          label: Text(loggedIn ? 'Profile' : 'Sign In'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: isWide
                            ? Row(
                                children: [
                                  Expanded(flex: 7, child: carouselCard()),
                                  const SizedBox(width: 16),
                                  Expanded(flex: 4, child: actionsCard()),
                                ],
                              )
                            : Column(
                                children: [
                                  Expanded(flex: 6, child: carouselCard()),
                                  const SizedBox(height: 16),
                                  Expanded(flex: 4, child: actionsCard()),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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
