import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsbooster/screens/campaign.dart';
import 'package:subsbooster/screens/like.dart';
import 'package:subsbooster/screens/points.dart';
import 'package:subsbooster/screens/subscribe.dart';
import 'package:subsbooster/screens/view.dart';



class BottomNavigationController extends GetxController{
  int currentIndex=0;

  List items=[
    SubscribeScreen(),
    LikeScreen(),
    ViewScreen(),
    CampaignScreen(),
    PointsScreen(),
  ].obs;

  onSelected(int index){
    currentIndex=index;
    update();
  }

}