import 'package:flutter/material.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_scaffold.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      body: Center(
        child: PageCard(
          title: 'LoginPage',
          child: IntrinsicWidth(
            child: PageColumn(
              spacing: 30.0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: Text(
                    "Register",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(
                  width: 450,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: const TextStyle(color: Colors.grey),
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
                SizedBox(
                  width: 450,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      hintStyle: const TextStyle(color: Colors.grey),
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
                SizedBox(
                  width: 400,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(color: Colors.grey),
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
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 50),
                  ),
                  onPressed: () {},
                  child: const Text("Register"),
                ),
                const Center(
                  child: Text(
                    "Already have account? Login",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
