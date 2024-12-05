import 'package:euchack/grocery.dart';
import 'package:euchack/providers/cam_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
    create: (context) => CameraProvider()..initializeCameras(),
    child: const MyApp(),
  ));
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
