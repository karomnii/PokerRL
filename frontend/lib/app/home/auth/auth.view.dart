import 'package:flutter/material.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_scaffold.dart';

class AuthView extends StatelessWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
        body: Center(
      child: PageCard(
        title: 'AuthPage',
        child: IntrinsicWidth(
          child: PageColumn(
              spacing: 30.0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("Login via", style: TextStyle(fontSize: 30)),
                SizedBox(
                  width: 400,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 400,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Login"),
                ),
                const Text("Don't have an account? Register"),
              ]),
        ),
      ),
    ));
  }
}
