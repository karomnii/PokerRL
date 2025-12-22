import 'package:flutter/material.dart';
import 'package:frontend/app/home/auth/login/login.controller.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class LoginView extends GetView<LoginPageController> {
  const LoginView({super.key});

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
                    title: 'LoginPage',
                    child: Center(
                      child: IntrinsicWidth(
                        child: PageColumn(
                          spacing: 30.0,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: SizedBox(
                                      width: 250,
                                      child: TextField(
                                        controller:
                                            controller.usernameController,
                                        decoration: InputDecoration(
                                          hintText: 'Username',
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          suffixIcon: const Icon(
                                            Icons.person,
                                            color: Colors.white,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: TextField(
                                      controller: controller.passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        hintText: 'Password',
                                        hintStyle:
                                            const TextStyle(color: Colors.grey),
                                        suffixIcon: const Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Obx(() => ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(100, 50),
                                      ),
                                      onPressed: controller.isLoading.value
                                          ? null
                                          : () => controller.login(),
                                      child: const Text("Login"),
                                    )),
                                const SizedBox(width: 20),
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  children: [
                                    const Text(
                                      "Don't have an account? ",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.toNamed('/auth/register',
                                            preventDuplicates: true);
                                      },
                                      child: const Text(
                                        "register",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
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
