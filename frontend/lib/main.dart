// main.dart
import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:frontend/api/swagger.swagger.dart';
import 'package:frontend/app/home/auth/register/register.controller.dart';
import 'package:frontend/routes/app_pages.dart';
import 'package:frontend/services/auth.service.dart';
import 'package:frontend/services/error_service.dart';
import 'package:frontend/theme/theme.dart';
import 'package:get/get.dart' as getx;

Future<void> main() async {
  setUrlStrategy(PathUrlStrategy());
  WidgetsFlutterBinding.ensureInitialized();

  getx.Get.put(ErrorService(), permanent: true);

  final swagger = Swagger.create(
    baseUrl: Uri.parse('https://localhost:65463'),
    converter: $JsonSerializableConverter(),
    interceptors: [
      AuthInterceptor(),
      ErrorInterceptor(),
    ],
  );
  getx.Get.put<Swagger>(swagger, permanent: true);
  await getx.Get.putAsync(() => AuthService().init());

  runApp(const MyApp());
}

/* ---------- interceptors ---------- */

/// Adds an `Authorization: Bearer …` header to every outgoing request.
class AuthInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final token = AuthService.to.token;
    final request = token == null
        ? chain.request
        : applyHeader(chain.request, 'Authorization', 'Bearer $token');
    return chain.proceed(request);
  }
}

/// Shows a bottom-left snackbar for any non-successful response and
/// logs the user out on HTTP 401.
class ErrorInterceptor implements Interceptor {
  @override
  FutureOr<Response<BodyType>> intercept<BodyType>(
      Chain<BodyType> chain) async {
    final response = await chain.proceed(chain.request);

    if (!response.isSuccessful) {
      ErrorService.to.showError(
          '${response.statusCode} ${response.error ?? response.bodyString}');
      if (response.statusCode == 401) AuthService.to.logout();
    }
    return response;
  }
}

/* ---------- UI ---------- */

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return getx.GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PokerRL',
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      getPages: appPages,
    );
  }
}
