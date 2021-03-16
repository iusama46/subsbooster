import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/controllers/bottomnavigationbar_controller.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/screens/bottomnavigationbar.dart';

class DrawerScreen extends StatelessWidget {
  BottomNavigationController BNcontroller =
      Get.put(BottomNavigationController());

  final User user;

  DrawerScreen({@required this.user});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Container(
          child: ListView(
            children: [
              Container(
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    colors: [KPink, KPurple],
                  )),
                  accountName: Text(user.email),
                  accountEmail: Text("Points : ${Service.points}"),
                  currentAccountPicture: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: NetworkImage(
                            user.photoURL,
                          ),
                          fit: BoxFit.fill),
                    ),
                  ),
                  // currentAccountPicture: CircleAvatar(
                  //   backgroundColor: KSecondaryColor,
                  //
                  //   backgroundImage: AssetImage("assets/subsboosterwithbg.png",),
                  // ),
                ),
              ),
              ListTile(
                onTap: () {
                  BNcontroller.onSelected(4);
                  Navigator.pop(context);
                  Get.off(BottomNavigationBarScreen());
                },
                leading: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        FontAwesome.dollar,
                        size: 12,
                        color: Colors.black,
                      )),
                ),
                title: Text("Buy Points"),
              ),
              ListTile(
                onTap: () {
                  BNcontroller.onSelected(0);
                  Navigator.pop(context);
                  Get.off(BottomNavigationBarScreen(), popGesture: false);
                },
                leading: Icon(
                  FontAwesome.youtube_play,
                  color: Colors.black,
                ),
                title: Text("Subscribe"),
              ),
              ListTile(
                onTap: () {
                  BNcontroller.onSelected(1);
                  Navigator.pop(context);
                  Get.off(BottomNavigationBarScreen());
                },
                leading: Icon(
                  FontAwesome.thumbs_up,
                  color: Colors.black,
                ),
                title: Text("Like"),
              ),
              ListTile(
                onTap: () {
                  BNcontroller.onSelected(2);
                  Navigator.pop(context);
                  Get.off(BottomNavigationBarScreen());
                },
                leading: Icon(
                  FontAwesome.play,
                  color: Colors.black,
                ),
                title: Text("View"),
              ),
              ListTile(
                onTap: () {
                  BNcontroller.onSelected(3);
                  Navigator.pop(context);
                  Get.off(BottomNavigationBarScreen());
                },
                leading: Image.asset(
                  "assets/campaign.png",
                  color: Colors.black,
                  width: 26,
                ),
                title: Text("Campaigns"),
              ),
              ListTile(
                onTap: () {},
                leading: Icon(
                  FontAwesome.user_secret,
                  color: Colors.black,
                ),
                title: Text("Privacy Policy"),
              ),
              ListTile(
                onTap: () {
                  exit(0);
                },
                leading: Icon(
                  FontAwesome.sign_out,
                  color: Colors.black,
                ),
                title: Text("Exit"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
