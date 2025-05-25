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

class HomePageView extends GetView<HomePageController> {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
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
          PopupMenuButton<String>(
            icon: Tooltip(
              message: 'Account',
              child: const Icon(
                Icons.person,
                size: 36.0,
              ),
            ),
            onSelected: (value) {
              switch (value) {
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
              final loggedIn = AuthService.to.isLoggedIn;
              return loggedIn
                  ? [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Logout',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ]
                  : [
                      const PopupMenuItem(
                        value: 'login',
                        child: Text('Login',
                            style: TextStyle(color: Colors.white)),
                      ),
                      const PopupMenuItem(
                        value: 'register',
                        child: Text('Register',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ];
            },
          ),
        ],
      ),
      body: Center(
          child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 500),
        child: PageCard(
          title: 'HomePage',
          child: Center(
            child: IntrinsicWidth(
              child: PageColumn(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PageRow(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('AI Casino',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(
                        width: 50,
                        child: Divider(
                          color: Colors.white,
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    width: 500,
                    'dices.png',
                    scale: 0.2,
                    fit: BoxFit.contain,
                  ),
                  ElevatedButton.icon(
                    onPressed: () =>
                        Get.toNamed('/games', preventDuplicates: false),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Play'),
                  ),
                  AuthService.to.isLoggedIn
                      ? const SizedBox.shrink()
                      : PageRow(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => Get.toNamed('/auth/',
                                    preventDuplicates: true),
                                icon: const Icon(Icons.person),
                                label: const Text('Sign In'),
                              ),
                            ),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: () => Get.toNamed('/auth/register',
                                    preventDuplicates: true),
                                icon: const Icon(Icons.person_add),
                                label: const Text('Sign up'),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
