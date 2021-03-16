import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:subsbooster/controllers/authentication.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';

class LikeScreen extends StatefulWidget {
  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool isLoaded = false;
  int i = 0;
  List<YVideo> videosList;
  User user;
  var _firebaseUserRef = FirebaseDatabase().reference().child('likes');

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    videosList = List<YVideo>();
    super.initState();
    //Utils.showToast('videos: ' + Service.likeVideosList.length.toString());

    if(Service.likeVideosList.isNotEmpty)
    getVideoData();
  }

  bool isAutoPlay = true;

  Future<void> likeVideo() async {
    int index = i;
    String token = Authentication.token;
    if (token == null)
      token =
          'ya29.a0AfH6SMBCl1f36GiBHngrgBKHlKS_oOGyeB8uQ3lPaqcOAsHulhIC3Amp4YpCjjRfM520o-Iy7gMNaXCl-dmin-q-30TwN63cNN7LIZ1dbAV07BjeECq9MCxSsPiDbWJgKQ_v5JEzzag1M6Qk38sUyDaY4i2N';

    var url =
        'https://youtube.googleapis.com/youtube/v3/videos/rate?id=${Service.likeVideosList[i].videoId.toString()}&rating=like&key=${Service.key}';
    final response = await http.post(url, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json; UTF-8',
    });
    print(response.body);

    if (response.statusCode == 204) {
      //Utils.showToast(videosList[index].title + " Liked");

      _firebaseUserRef.child(Service.likeVideosList[index].id).update({
        'completed': Service.likeVideosList[index].completed + 1,
      }).whenComplete(() => {
            _firebaseUserRef
                .child(Service.likeVideosList[index].id)
                .child('liked')
                .update({user.uid: user.uid}).whenComplete(() {
              Service.firebaseUserRef
                  .child(user.uid)
                  .update({'points': Service.points + 5}).whenComplete(
                      () => Service.points += 5);
            })
          });
    } else {
      //Utils.showToast('Update Token');
    }
    setState(() {});
    print('cd' + response.statusCode.toString());
    print('Token : ${token}');
  }

  Future<void> getVideoData() async {
    videosList.clear();
    // var url =
    //     'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw&maxResults=10&order=date&type=video&key=AIzaSyBtw_M5xFUY77OpiUFi_2DIcV_BC5ONRfY';

    for (int i = 0; i < Service.likeVideosList.length; i++) {
      var url2 =
          'https://www.googleapis.com/youtube/v3/videos?id=${Service.likeVideosList[i].videoId}&key=${Service.key}&part=snippet,contentDetails,statistics,status';
      var response1 = await http.get(
        url2,
      );
      var data2 = jsonDecode(response1.body);
      isLoaded = true;
      videosList.add(YVideo(
          title: data2['items'][0]['snippet']['title'],
          thumbnail: data2['items'][0]['snippet']['thumbnails']['high']['url'],
          id: data2['items'][0]['id'],
          like: data2['items'][0]['statistics']['likeCount']));
      print(data2['items'][0]['snippet']['title']);
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Service.likeVideosList.isEmpty?Center(child: Text('No Videos Right now'),): !isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                      child: Card(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () {
                            String url =
                                'https://www.youtube.com/watch?v=${Service.likeVideosList[i].videoId}';
                            _launchURL(url);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(vertical: 15),
                                  child: videosList.length != 0
                                      ? Image.network(videosList[i].thumbnail)
                                      : Image.asset("assets/youtubelike.png"),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image:
                                          AssetImage("assets/youtubelike.png"),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    videosList.length != 0
                                        ? videosList[i].title
                                        : "Video Id : ${Service.likeVideosList[i].videoId}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Card(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 15, top: 5),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Auto Play",
                                style: TextStyle(fontSize: 10),
                              ),
                              Visibility(
                                visible: true,
                                child: Switch(
                                    inactiveThumbColor: KSecondaryColor,
                                    activeColor: KSecondaryColor,
                                    inactiveTrackColor:
                                        KSecondaryColor.withOpacity(0.4),
                                    value: false,
                                    onChanged: (value) {
                                      //getVideoData();
                                    }),
                              ),
                            ],
                          ),
                          Text(
                            "Like to yuor favorite Video &  get bonus, DO NOT cancle like, We will block your account if you cancle like on any video",
                            style: TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FlatButton(
                          color: KSecondaryColor,
                          minWidth: Get.width * 0.4,
                          onPressed: () {
                            likeVideo();
                            int temp = i + 1;
                            if (temp == Service.likeVideosList.length) {
                              Utils.showToast('No more Videos');
                              return;
                            }

                            i++;
                          },
                          child: FittedBox(
                              child: Text(
                            videosList.length != 0
                                ? "LIKE ( + ${videosList[i].like})"
                                : "LIKE ( + 1200)",
                            style:
                                TextStyle(fontSize: 10, color: KPrimaryColor),
                          )),
                        ),
                        FlatButton(
                          color: KSecondaryColor,
                          minWidth: Get.width * 0.4,
                          onPressed: () {
                            setState(() {
                              int temp = i + 1;
                              if (temp == Service.likeVideosList.length) {
                                Utils.showToast('No more Videos');
                                return;
                              } else
                                i++;
                            });
                          },
                          child: FittedBox(
                              child: Text(
                            "SEE NEXT",
                            style:
                                TextStyle(fontSize: 10, color: KPrimaryColor),
                          )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
