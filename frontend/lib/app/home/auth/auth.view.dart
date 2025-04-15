import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                  width: 300,
                  child: Center(
                    child: Text(
                      "Login in with",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                _socialButton(
                  label: "Google",
                  iconUrl:
                      'https://raw.githubusercontent.com/gauravghongde/social-icons/9d939e1c5b7ea4a24ac39c3e4631970c0aa1b920/SVG/Color/Google.svg',
                  color: Colors.red,
                  onPressed: () {},
                ),
                _socialButton(
                  label: "Facebook",
                  iconUrl:
                      'https://raw.githubusercontent.com/gauravghongde/social-icons/9d939e1c5b7ea4a24ac39c3e4631970c0aa1b920/SVG/Color/Facebook.svg',
                  color: Colors.indigo,
                  onPressed: () {},
                ),
                _socialButton(
                  label: "Twitter",
                  iconUrl:
                      'https://raw.githubusercontent.com/gauravghongde/social-icons/9d939e1c5b7ea4a24ac39c3e4631970c0aa1b920/SVG/Color/Twitter.svg',
                  color: Colors.lightBlue,
                  onPressed: () {},
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

  Widget _socialButton({
    required String label,
    required String iconUrl,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          backgroundColor: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            SvgPicture.network(
              iconUrl,
            ),
          ],
        ),
      ),
    );
  }
}
