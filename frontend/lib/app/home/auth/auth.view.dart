import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
                const SizedBox(
                  width: 450,
                  child: Center(
                    child: (Text(
                      "Login in threw Social Media",
                      style: TextStyle(fontSize: 30),
                    )),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Login with Google"),
                  icon: SvgPicture.network(
                    'https://raw.githubusercontent.com/gauravghongde/social-icons/9d939e1c5b7ea4a24ac39c3e4631970c0aa1b920/SVG/Color/Google.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Login with Facebook"),
                  icon: SvgPicture.network(
                    'https://raw.githubusercontent.com/gauravghongde/social-icons/9d939e1c5b7ea4a24ac39c3e4631970c0aa1b920/SVG/Color/Facebook.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Login with Twitter"),
                  icon: SvgPicture.network(
                    'https://raw.githubusercontent.com/gauravghongde/social-icons/9d939e1c5b7ea4a24ac39c3e4631970c0aa1b920/SVG/Color/Twitter.svg',
                    width: 30,
                    height: 30,
                  ),
                ),
                const Center(
                  child: Text(
                    "Or use your password to login",
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
