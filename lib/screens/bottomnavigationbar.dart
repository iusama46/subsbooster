import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/controllers/bottomnavigationbar_controller.dart';
import 'package:subsbooster/screens/drawer.dart';
import 'package:subsbooster/screens/widgets/appBarWidgets.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  @override
  _BottomNavigationBarScreenState createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  BottomNavigationController BNcontroller =
      Get.put(BottomNavigationController());
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    print(user.displayName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      drawer: DrawerScreen(
        user: user,
      ),
      body: GetBuilder<BottomNavigationController>(
          init: BottomNavigationController(),
          builder: (controller) {
            return controller.items[controller.currentIndex];
          }),
      bottomNavigationBar: GetBuilder<BottomNavigationController>(
        init: BottomNavigationController(),
        builder: (controller) {
          return bottomNavigationBar(controller);
        },
      ),
    );
  }

  BottomNavigationBar bottomNavigationBar(controller) {
    return BottomNavigationBar(
      elevation: 3,
      currentIndex: controller.currentIndex,
      selectedItemColor: KSecondaryColor,
      onTap: (index) {
        BNcontroller.onSelected(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesome.youtube_play,
            color: controller.currentIndex == 0 ? KSecondaryColor : KGreyColor,
          ),
          // ignore: deprecated_member_use
          title: controller.currentIndex == 0
              ? Text("Subscribe")
              : SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesome.thumbs_up,
            color: controller.currentIndex == 1 ? KSecondaryColor : KGreyColor,
          ),
          // ignore: deprecated_member_use
          title:
              controller.currentIndex == 1 ? Text("Like") : SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            FontAwesome.play,
            color: controller.currentIndex == 2 ? KSecondaryColor : KGreyColor,
          ),
          title:
              controller.currentIndex == 2 ? Text("View") : SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            "assets/campaign.png",
            color: controller.currentIndex == 3 ? KSecondaryColor : KGreyColor,
            width: 22,
          ),
          title: controller.currentIndex == 3
              ? Text("Campaign")
              : SizedBox.shrink(),
        ),
        BottomNavigationBarItem(
          icon: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(
                  color: controller.currentIndex == 4
                      ? KSecondaryColor
                      : KGreyColor,
                  width: 1.2),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: controller.currentIndex == 4
                          ? KSecondaryColor
                          : KGreyColor,
                      width: 1.2),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  FontAwesome.dollar,
                  color: controller.currentIndex == 4
                      ? KSecondaryColor
                      : KGreyColor,
                  size: 12,
                )),
          ),
          title:
              controller.currentIndex == 4 ? Text("Points") : SizedBox.shrink(),
        ),
      ],
    );
  }
}
