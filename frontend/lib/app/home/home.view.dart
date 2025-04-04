import 'package:flutter/material.dart';
import 'package:frontend/app/home/home.controller.dart';
import 'package:get/get.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(child: Text('Home Page')),
          backgroundColor: const Color.fromARGB(129, 177, 173, 247)),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset('background.png', repeat: ImageRepeat.repeat))
        ],
      ),
    );
  }
}
