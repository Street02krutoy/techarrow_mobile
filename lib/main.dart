import 'package:flutter/material.dart';
import 'package:techarrow_mobile/screens/main/main_screen.dart';
import 'package:techarrow_mobile/storage/storage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApplicationStorage().initialize();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: MainScreen());
  }
}
