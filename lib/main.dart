import 'package:camera/camera.dart';
import 'package:cemera_app/starting_page.dart';
import 'package:flutter/material.dart';

 Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(   const MyApp());
}

class MyApp extends StatelessWidget {
  


  const MyApp({super.key,});

  
  @override
  Widget build(BuildContext context) {
    return    const MaterialApp(
      home: StartingPage(),
    );
  }
}

