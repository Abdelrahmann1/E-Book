import 'package:device_preview/device_preview.dart';
import 'package:ebook/views/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    test
    DevicePreview(
      enabled: false, 
      tools: const [
        ...DevicePreview.defaultTools,
      ],
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Book Borrowing App',
      builder: DevicePreview.appBuilder, 
      home: HomeScreen(),
    );
  }
}

