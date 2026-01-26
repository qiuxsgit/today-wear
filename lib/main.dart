import 'package:flutter/material.dart';
import 'screens/outfit_list.dart';

void main() {
  runApp(const MyApp());
}

/// App 根组件
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '今日穿什麼',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.pink,
        ),
        useMaterial3: true,
      ),
      home: const OutfitListPage(),
    );
  }
}
