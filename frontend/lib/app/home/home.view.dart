import 'package:flutter/material.dart';
import 'package:frontend/app/home/home.controller.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:frontend/widgets/page_scaffold.dart';
import 'package:get/get.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return const ThemedScaffold(
      appBar: ThemedAppBar(
        title: 'Home Page',
      ),
      body: Center(child: Text('Your content goes here')),
    );
  }
}
