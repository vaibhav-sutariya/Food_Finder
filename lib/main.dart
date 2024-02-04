import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:no_hunger/constants.dart';
import 'package:no_hunger/firebase_options.dart';
import 'package:no_hunger/screens/intiScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: AppTheme.lightTheme(context),
      theme: ThemeData(fontFamily: fontfamily),
      title: 'Food Finder',
      home: const MyHomePage(
        title: 'Food Finder',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final PageController _pageController = PageController();
  // int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    return const Scaffold(
      body: InitScreen(),
    );
  }
}
