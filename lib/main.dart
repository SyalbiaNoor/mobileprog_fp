import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash_screen.dart'; // import the splash screen
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const GatherUpApp());
}

class GatherUpApp extends StatelessWidget {
  const GatherUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GatherUp',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false, // removes the debug banner
      home: const SplashScreen(), // set splash screen as the initial screen
    );
  }
}
