

import 'package:flutter/material.dart';
import 'package:no_hunger/screens/Fav_screen.dart';
import 'package:no_hunger/screens/acccount_screen.dart';
import 'package:no_hunger/screens/home_screen.dart';
import 'package:no_hunger/screens/search_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bottom Navbar',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          color: Colors.green[700],
        ),
      ),
      home: const MyHomePage(title: 'Food Finder'),
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
  final PageController _pageController = PageController();
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          buildPageView(),
          buildBottomNav(),
        ],
      ),
      appBar: AppBar(
        title: Text(
          'Food Finder',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.star_border_outlined,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_active,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }


  Widget buildPageView() {
    return Expanded(
      child: SizedBox(
        //  height: MediaQuery
            // .of(context)
            // .size
            // .height * 0.8409,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const HomeScreen(),
            SearchScreen(),
            RestaurantList(),
            AccountScreen(),
          ],
          onPageChanged: (index) {
            onPageChange(index);
          },
        ),
      ),
    );
  }

  Widget buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.shifting,
      backgroundColor: Colors.indigo,
      currentIndex: selectedPage,
      items: [
        BottomNavigationBarItem(
            label: 'Home',
            icon: const Icon(Icons.home),
        backgroundColor: Colors.green[700],

        ),


        BottomNavigationBarItem(
            label: 'Search',
            icon: Icon(Icons.search),
        backgroundColor: Colors.green[700]
        ),

        BottomNavigationBarItem(
            label: 'Food Places',
            icon: Icon(Icons.list_alt_sharp),
        backgroundColor: Colors.green[700]
        ),

        BottomNavigationBarItem(
            label: 'Account',
            icon: Icon(Icons.account_box_sharp),
        backgroundColor: Colors.green[700]
        ),
      ],

      onTap: (int index) {
        _pageController.animateToPage(
            index, duration: const Duration(microseconds: 1000), curve: Curves.easeIn);
      },
    );
  }

  onPageChange(int index){
    setState(() {
      selectedPage = index;
    });
  }

}