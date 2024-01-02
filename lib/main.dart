import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:timer_getx/ui/timer_page.dart';

import 'ui/timer_page2.dart';
import 'ui/timer_page3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const TimerPage3(),
    );
  }
}
