import 'package:flutter/material.dart';
import 'package:frontend/app/home/auth/register/register.controller.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

class RegisterView extends GetView<RegisterPageController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 650),
          child: Obx(
            () => PageCard(
              title: 'RegisterPage',
              child: Center(
                child: IntrinsicWidth(
                  child: PageColumn(
                    spacing: 30.0,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: 250,
                              child: TextField(
                                controller: controller.usernameController,
                                decoration: InputDecoration(
                                  hintText: 'Username',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  suffixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: 250,
                              child: TextField(
                                controller: controller.emailController,
                                decoration: InputDecoration(
                                  hintText: 'E-mail',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  suffixIcon: const Icon(
                                    Icons.mail,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: SizedBox(
                              width: 250,
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
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(0),
                            child: Row(
                              children: [
                                AppBarIcon(
                                  icon: Icons.info_sharp,
                                  iconColor: Colors.white,
                                  tooltipText: 'Privacy Policy',
                                  padding: EdgeInsets.all(1.0),
                                  onPressed: () => Get.toNamed('/policy',
                                      preventDuplicates: false),
                                ),
                                Text('Accept privacy policy'),
                                Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: Transform.scale(
                                    scale: 1.4,
                                    child: Checkbox(
                                      value: controller.checkedPolicy.value,
                                      onChanged: (newValue) {
                                        controller.checkedPolicy.value =
                                            newValue ?? false;
                                        print(controller.checkedPolicy.value);
                                      },
                                      fillColor:
                                          WidgetStatePropertyAll(Colors.white),
                                      checkColor: Colors.black,
                                      side: const BorderSide(
                                          color: Colors.black87, width: 2),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(100, 50),
                            ),
                            onPressed: controller.checkedPolicy.value
                                ? () => controller.register()
                                : null,
                            child: const Text("Register"),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                "Already have account? ",
                                style: TextStyle(fontSize: 16),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed('/auth/login',
                                      preventDuplicates: true);
                                },
                                child: const Text(
                                  "login",
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
  }
}
