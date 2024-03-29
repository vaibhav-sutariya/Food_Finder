import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:no_hunger/components/belowAppbar.dart';
import 'package:no_hunger/constants.dart';
import 'package:no_hunger/screens/addFood/addFoodDetails.dart';
import 'package:no_hunger/screens/main/bottomBar.dart';
import 'package:no_hunger/screens/sign_in/sign_in_screen.dart';

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        title: const Text(
          'Food Finder',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AddressBox(),
          Expanded(
            child: Container(
              // decoration: const BoxDecoration(
              //   image: DecorationImage(
              //       image: NetworkImage(
              //           "https://c0.wallpaperflare.com/preview/116/193/176/blur-blurred-background-citrus-close-up.jpg"), // Replace with your image asset path
              //       fit: BoxFit.cover,
              //       opacity: 10),
              // ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Are You Hungry??'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.restaurant),
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const BottomBar(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: kPrimaryColor, // Text color
                        padding: const EdgeInsets.all(16), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                        elevation: 5, // Elevation (shadow)
                        minimumSize:
                            const Size(double.infinity, 0), // Full width
                      ),
                      label: const Text(
                        'Find Food',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('You have Remaining Food??'),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        // Check if the user is logged in with Firebase Authentication
                        User? user = FirebaseAuth.instance.currentUser;

                        if (user != null) {
                          // If logged in, navigate to AddFoodDetailsScreen
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => const AddFoodDetails(),
                            ),
                          );
                        } else {
                          // If not logged in, navigate to SignInScreen
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SignInScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.green[700], // Text color
                        padding: const EdgeInsets.all(16), // Button padding
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // Rounded corners
                        ),
                        elevation: 5, // Elevation (shadow)
                        minimumSize:
                            const Size(double.infinity, 0), // Full width
                      ),
                      label: const Text(
                        'Add Food',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
