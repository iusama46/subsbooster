import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsbooster/constant.dart';



class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("User Profile"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage("assets/subsboosterwithbg.png"),
            ),
            SizedBox(height: 10,),
            Text("Lofty123@gmail.com"),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Points: ",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                Text("450",style: TextStyle(fontSize: 16),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
