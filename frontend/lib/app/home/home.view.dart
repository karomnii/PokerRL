import 'package:flutter/material.dart';
import 'package:frontend/app/home/home.controller.dart';
import 'package:get/get.dart';

class HomePageView extends GetView<HomePageController> {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rx Page')),
      body: Center(
          child: Column(
        children: [
          Obx(
            () => Text(
              '${controller.counter.value}',
              style: const TextStyle(fontSize: 250),
            ),
          ),
          FilledButton(
              onPressed: controller.addOne, child: const Text('Powiekszanie'))
        ],
      )),
    );
  }
}
