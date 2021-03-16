import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/controllers/authentication.dart';
import 'package:subsbooster/screens/bottomnavigationbar.dart';

class SignWithGoogle extends StatefulWidget {
  @override
  _SignWithGoogleState createState() => _SignWithGoogleState();
}

class _SignWithGoogleState extends State<SignWithGoogle> {
  Authentication authentication = Authentication();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/subsboosterwithbg.png",
              height: 100,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "SubsBooster",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Promote your channel",
              style: TextStyle(fontSize: 14, color: KGreyColor),
            ),
            SizedBox(
              height: 20,
            ),
            GoogleAuthButton(
              width: 220,
              separator: 10,
              onPressed: () async {
                await authentication.signInWithGoogle().whenComplete(() {
                  User user = FirebaseAuth.instance.currentUser;
                  print('User ${user.email}');

                  Get.offAll(BottomNavigationBarScreen());
                });
              },

              //},
              textStyle: TextStyle(
                color: KGreyColor,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Privacy Policy",
            textAlign: TextAlign.center,
            style: TextStyle(color: KSecondaryColor),
          ),
        ),
      ),
    );
  }
}
