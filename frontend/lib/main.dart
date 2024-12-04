import 'package:euchack/constants/colors.dart';
import 'package:euchack/grocery.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Euc24',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const GroceryPage(),
    );
  }
}
