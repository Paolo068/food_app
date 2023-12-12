import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_app/features/home/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/constants/styles_constants.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('appBox');
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'BrandonGrotesque',
        colorScheme: ColorScheme.fromSeed(seedColor: Pallete.orange),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
