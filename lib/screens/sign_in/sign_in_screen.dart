
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../components/no_account_text.dart';
import '../../components/socal_card.dart';
import 'components/sign_form.dart';

// ignore: must_be_immutable
class SignInScreen extends StatelessWidget {
  ValueNotifier userCredential = ValueNotifier('');

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }

  SignInScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Sign in with your email and password  \nor continue with social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignForm(),
                  const SizedBox(height: 16),
                  Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text("  OR  "),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () async {
                          userCredential.value = await signInWithGoogle();
                          if (userCredential.value != null)
                            print(userCredential.value.user!.email);
                          // Navigator.pushReplacement(
                          //   context,
                          //   CupertinoPageRoute(
                          //     builder: (context) => LoginSuccessScreen(),
                          //   ),
                          // );
                        },
                      ),
                      // SocalCard(
                      //   icon: "assets/icons/facebook-2.svg",
                      //   press: () {},
                      // ),
                      // SocalCard(
                      //   icon: "assets/icons/twitter.svg",
                      //   press: () {},
                      // ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
