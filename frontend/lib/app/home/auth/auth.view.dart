import 'package:flutter/material.dart';
import 'package:frontend/app/home/auth/auth.controller.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class AuthView extends GetView<AuthPageController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: PageCard(
                    title: 'AuthPage',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 10.0),
                      child: PageColumn(
                        spacing: 30.0,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(
                            child: Text(
                              "Log in with",
                              style: TextStyle(fontSize: 24),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: Obx(() {
                                    //Jak chcecie to se zmiencie ten przycisk do logowania (Piotrek)
                                    final isEnabled =
                                        controller.checkedPolicy.value;
                                    return ElevatedButton(
                                      onPressed: isEnabled
                                          ? () => controller.loginWithGoogle()
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        elevation: isEnabled ? 2 : 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(4.0),
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Image.network(
                                              'https://developers.google.com/identity/images/g-logo.png',
                                              height: 18,
                                              errorBuilder: (context, error,
                                                      stackTrace) =>
                                                  const Icon(Icons.error,
                                                      size: 18,
                                                      color: Colors.red),
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            "Google",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              AppBarIcon(
                                                icon: Icons.info_sharp,
                                                iconColor: Colors.white,
                                                tooltipText: 'Privacy Policy',
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                onPressed: () => Get.toNamed(
                                                    '/policy',
                                                    preventDuplicates: false),
                                              ),
                                              const Expanded(
                                                child: Text(
                                                  'Accept privacy policy',
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Obx(() => Transform.scale(
                                              scale: 1.2,
                                              child: Checkbox(
                                                value: controller
                                                    .checkedPolicy.value,
                                                onChanged: (newValue) {
                                                  controller
                                                          .checkedPolicy.value =
                                                      newValue ?? false;
                                                },
                                                fillColor:
                                                    const WidgetStatePropertyAll(
                                                        Colors.white),
                                                checkColor: Colors.black,
                                                side: const BorderSide(
                                                    color: Colors.black87,
                                                    width: 2),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.white54,
                            thickness: 1,
                          ),
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 5,
                              children: [
                                const Text(
                                  'Or use your password to',
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  onTap: () => Get.toNamed('/auth/login',
                                      preventDuplicates: true),
                                  child: const Text(
                                    'login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const Text(
                                  'or',
                                  style: TextStyle(fontSize: 16),
                                ),
                                InkWell(
                                  onTap: () => Get.toNamed('/auth/register',
                                      preventDuplicates: true),
                                  child: const Text(
                                    'register',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
