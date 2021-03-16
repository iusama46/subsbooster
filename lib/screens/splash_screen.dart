import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/controllers/authentication.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/screens/bottomnavigationbar.dart';
import 'package:subsbooster/screens/signinwithgoogle.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Authentication authentication = Authentication();

  var _firebaseRef = FirebaseDatabase().reference().child('videos');
  var _firebaseLikeRef = FirebaseDatabase().reference().child('likes');
  var _firebaseChannelRef = FirebaseDatabase().reference().child('channels');
  var _firebaseUserRef = FirebaseDatabase().reference().child('users');

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((User user) async {
      if (user == null) {
        print('User is currently signed out!');
        Get.offAll(SignWithGoogle());
      } else {
        print('User is signed in!');
        await authentication.signInWithGoogle().whenComplete(() async {
          print('Splash!');

          try {
            await _firebaseUserRef
                .child(user.uid)
                .child('points')
                .once()
                .then((value) {
              print('hello ' + value.value.toString());
              Service.points = int.parse(value.value.toString());
              print(Service.points.toString());
            });
          } catch (e) {
            await _firebaseUserRef.child(user.uid).update({'points': 450});
          }

          await _firebaseRef.once().then((snap) async {
            print(snap.value.entries.length);
            Service.videosList.clear();
            Map data = snap.value;
            List item = [];
            print(snap.value.toString());
            data.forEach((index, data) => item.add({"key": index, ...data}));
            for (int i = 0; i < item.length; i++) {
              CVideo cvideo = CVideo(
                  id: item[i]['key'],
                  videoId: item[i]['videoId'],
                  points: item[i]['points'],
                  views: item[i]['views'],
                  completed: item[i]['completed'],
                  duration: item[i]['duration'],
                  userId: item[i]['uId']);

              try {
                if (!(cvideo.completed >= int.parse(cvideo.views))) {
                  if (item[i]['viewed'] != null) {
                    print('hello, '+item[i]['viewed'].toString());
                    if (!item[i]['viewed'].toString().contains(user.uid))
                      Service.videosList.add(cvideo);
                  } else
                    Service.videosList.add(cvideo);
                }
              } catch (e) {
                Service.videosList.add(cvideo);
              }
            }
            /*  print(Service.videosList[0].videoId);
            print(Service.videosList[1].videoId);*/


//////////////////////////////////////////////////////////////////
            await _firebaseLikeRef.once().then((snap) {
              print('hi2');
              print(snap.value.entries.length);
              Service.likeVideosList.clear();
              Map data = snap.value;
              List item = [];
              print(snap.value.toString());
              data.forEach((index, data) => item.add({"key": index, ...data}));
              print('d' + item[0].toString());
              for (int i = 0; i < item.length; i++) {
                CVideo cvideo = CVideo(
                    id: item[i]['key'],
                    videoId: item[i]['videoId'],
                    points: item[i]['points'],
                    views: item[i]['views'],
                    completed: item[i]['completed'],
                    duration: item[i]['duration'],
                    userId: item[i]['uId']);




                try {
                  if (!(cvideo.completed >= int.parse(cvideo.views))) {
                    if (item[i]['liked'] != null) {

                      if (!item[i]['liked'].toString().contains(user.uid))
                        Service.likeVideosList.add(cvideo);
                    } else
                      Service.likeVideosList.add(cvideo);
                  }
                } catch (e) {
                  Service.likeVideosList.add(cvideo);
                }
              }

            });

            await _firebaseChannelRef
                .orderByChild('subscribed')
                .once()
                .then((snap) {
              print('hi3');
              print(snap.value.entries.length);
              Service.channelsList.clear();
              Map data = snap.value;
              List item = [];
              print(snap.value.toString());
              data.forEach((index, data) => item.add({"key": index, ...data}));
              print('d' + item[0].toString());
              for (int i = 0; i < item.length; i++) {
                YChannel cvideo = YChannel(
                    id: item[i]['key'],
                    channelId: item[i]['channelId'],
                    //  points: item[i]['points'],
                    completed: item[i]['completed'],
                    target: item[i]['subscribers'],
                    userId: item[i]['uId']);

                if (!(cvideo.completed >=
                    int.parse(cvideo.target))) if (!item[i]
                        ['subscribed']
                    .toString()
                    .contains(user.uid)) Service.channelsList.add(cvideo);
              }

              Get.offAll(BottomNavigationBarScreen());
            });
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KSecondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/goal.png",
              color: Colors.white,
              height: 130,
              filterQuality: FilterQuality.high,
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Checking Subscriptions & Likes",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            CircularProgressIndicator(
              backgroundColor: KPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
