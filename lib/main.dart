import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const GoSportApp());
}

class GoSportApp extends StatelessWidget {
  const GoSportApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GoSport',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
