import 'dart:ui' as ui; // ignore: undefined_prefixed_name
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/widgets/app_bar/app_bar_icon.dart';
import 'package:frontend/widgets/page_card.dart';
import 'package:frontend/widgets/page_column.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'auth.controller.dart';

// TODO: MICHAL NAPRAW
// void registerGoogleSignInButton(String clientId) {
//   // ignore: undefined_prefixed_name
//   ui.platformViewRegistry.registerViewFactory(
//     'google-signin-button',
//     (int viewId) {
//       final html.DivElement element = html.DivElement()
//         ..id = 'google-signin-button-container'
//         ..style.width = '300px'
//         ..style.height = '40px';

//       final script = html.ScriptElement()
//         ..type = 'text/javascript'
//         ..text = '''
//           function initializeGoogleSignIn() {
//             google.accounts.id.initialize({
//               client_id: "$clientId",
//               callback: function(response) {
//                 window.dispatchEvent(new CustomEvent('googleSignIn', {detail: response.credential}));
//               }
//             });
//             google.accounts.id.renderButton(
//               document.getElementById('google-signin-button-container'),
//               { theme: 'outline', size: 'large', width: 300 }
//             );
//           }
//           if (typeof google !== 'undefined' && google.accounts && google.accounts.id) {
//             initializeGoogleSignIn();
//           } else {
//             var script = document.createElement('script');
//             script.src = "https://accounts.google.com/gsi/client";
//             script.onload = initializeGoogleSignIn;
//             document.head.appendChild(script);
//           }
//         ''';

//       element.append(script);

//       return element;
//     },
//   );
// }

class AuthView extends StatefulWidget {
  AuthView({Key? key}) : super(key: key);

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final AuthPageController controller = Get.put(AuthPageController());

  @override
  void initState() {
    super.initState();

    // TODO: MICHAL NAPRAW
    // if (kIsWeb) {
    //   registerGoogleSignInButton(controller.googleClientId);
    //   html.window.addEventListener('googleSignIn', (event) {
    //     final customEvent = event as html.CustomEvent;
    //     final String idToken = customEvent.detail;
    //     if (idToken.isNotEmpty) {
    //       controller.loginWithGoogleIdToken(idToken);
    //     }
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: PageCard(
            title: 'AuthPage',
            titleExtras: [
              AppBarIcon(
                icon: Icons.info_sharp,
                tooltipText: 'Privacy Policy',
                iconColor: Colors.white,
                onPressed: () =>
                    Get.toNamed('/policy', preventDuplicates: false),
              ),
            ],
            child: Center(
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
                    if (kIsWeb)
                      SizedBox(
                        width: 300,
                        height: 40,
                        child:
                            HtmlElementView(viewType: 'google-signin-button'),
                      ),
                    SizedBox(
                      width: 50,
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                    Center(
                      child: Wrap(
                        alignment: WrapAlignment.center,
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
                            onTap: () => Get.offNamed('/auth/register',
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
  }
}
