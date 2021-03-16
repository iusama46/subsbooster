import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:subsbooster/screens/MembershipScreen.dart';
import 'package:subsbooster/screens/buyPoints.dart';
import 'package:subsbooster/screens/widgets/appBarWidgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';
import 'drawer.dart';

class PointsScreen extends StatefulWidget {
  @override
  _PointsScreenState createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  showRatingDialogueBox() {
    return Container(
      child: Column(
        children: [
          Expanded(child: Container()),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
              width: Get.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Image.asset(
                    "assets/subsbooster.png",
                    height: 100,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "How was your experience with us?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: KSecondaryColor,
                    ),
                    onRatingUpdate: (rating) {
                      print(rating);
                      if(rating==5){
                        String url = 'https://play.google.com/store/apps';
                        _launchURL(url);
                      }
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: Text(
                      "Maybe later",
                      style: TextStyle(
                          color: KSecondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 150,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/shopping.png",
                        height: 60,
                      ),
                      FlatButton(
                        color: KSecondaryColor,
                        minWidth: Get.width * 0.75,
                        onPressed: () {
                          Get.to(BuyPointsScreen());
                        },
                        child: FittedBox(
                            child: Text(
                          "BUY POINTS",
                          style: TextStyle(fontSize: 10, color: KPrimaryColor),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/vip.png",
                        height: 60,
                      ),
                      FlatButton(
                        color: KSecondaryColor,
                        minWidth: Get.width * 0.75,
                        onPressed: () {
                          Get.to(MembershipScreen());
                        },
                        child: FittedBox(
                            child: Text(
                          "VIP MEMBERSHIP",
                          style: TextStyle(fontSize: 10, color: KPrimaryColor),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 150,
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/subsbooster.png",
                        height: 60,
                      ),
                      FlatButton(
                        color: KSecondaryColor,
                        minWidth: Get.width * 0.75,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return showRatingDialogueBox();
                            },
                          );
                        },
                        child: FittedBox(
                            child: Text(
                          "LEAVE FEEDBACK",
                          style: TextStyle(fontSize: 10, color: KPrimaryColor),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
