import 'package:flutter/material.dart';
import 'package:no_hunger/screens/main/screens/Fav_screen.dart';
import 'package:no_hunger/screens/main/screens/home_screen.dart';
import 'package:no_hunger/screens/main/screens/search_page.dart';
import 'package:no_hunger/screens/sign_in/sign_in_screen.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  final PageController _pageController = PageController();
  int selectedPage = 0;
  @override
  Widget build(BuildContext context) {
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
        title: const Text(
          'Food Finder',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
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
            RestaurantList(),
            SignInScreen(),
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
            label: 'Food Places',
            icon: const Icon(Icons.list_alt_sharp),
            backgroundColor: Colors.green[700]),
        BottomNavigationBarItem(
            label: 'Account',
            icon: const Icon(Icons.account_box_sharp),
            backgroundColor: Colors.green[700]),
      ],
      onTap: (int index) {
        _pageController.animateToPage(index,
            duration: const Duration(microseconds: 1000), curve: Curves.easeIn);
      },
    );
  }

  onPageChange(int index) {
    setState(() {
      selectedPage = index;
    });
  }
}
