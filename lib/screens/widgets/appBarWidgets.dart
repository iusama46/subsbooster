import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/screens/userProfile.dart';

import '../../constant.dart';



  Widget appBarWidget() {
    return AppBar(
      title: Text("SubsBooster",),
      centerTitle: true,
      actions: [
        GestureDetector(
          onTap: (){
            Get.to(UserProfile());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(Service.points.toString(), style: TextStyle(fontSize: 15),),
                  SizedBox(width: 5,),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: icondecoration,
                    child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: icondecoration,
                        child: Icon(FontAwesome.dollar, size: 12,)),
                  ),
                  SizedBox(width: 10,),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }