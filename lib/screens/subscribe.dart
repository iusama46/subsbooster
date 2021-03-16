import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/controllers/authentication.dart';
import 'package:subsbooster/models/channel.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/utils/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class SubscribeScreen extends StatefulWidget {
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  var _subscribers = 0;
  User user;

  int i = 0;
  var _firebaseUserRef = FirebaseDatabase().reference().child('channels');
  bool isLoaded = false;

  List<YtChannel> ytList = List<YtChannel>();

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    getChannelData();
    user = FirebaseAuth.instance.currentUser;
    //Utils.showToast('channels: ' + Service.channelsList.length.toString());
  }

  bool isAutoPlay = true;

  Future<void> subscribeChannel() async {
    String token = Authentication.token;
    int temp = i;
    var tempId = Service.channelsList[i].channelId.toString();
    if (token == null)
      token =
          'ya29.a0AfH6SMBCl1f36GiBHngrgBKHlKS_oOGyeB8uQ3lPaqcOAsHulhIC3Amp4YpCjjRfM520o-Iy7gMNaXCl-dmin-q-30TwN63cNN7LIZ1dbAV07BjeECq9MCxSsPiDbWJgKQ_v5JEzzag1M6Qk38sUyDaY4i2N';
    print('Token : ${token}');

    var body = jsonEncode({
      "snippet": {
        "resourceId": {"kind": "youtube#channel", "channelId": tempId}
      }
    });
    var url =
        'https://youtube.googleapis.com/youtube/v3/subscriptions?part=snippet&key=${Service.key}';
    final response = await http.post(url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body);
    print(response.body);

    if (response.statusCode == 204 ||
        response.statusCode == 200 ||
        response.statusCode == 400) {
      _firebaseUserRef.child(Service.channelsList[temp].id).update({
        'completed': Service.channelsList[i].completed + 1,
      }).whenComplete(() {
        _firebaseUserRef
            .child(Service.channelsList[temp].id)
            .child('subscribed')
            .update({user.uid: user.uid}).whenComplete(() {
          Service.firebaseUserRef
              .child(user.uid)
              .update({'points': Service.points + 20}).whenComplete(
                  () => Service.points += 20);
        });
      });
     // Utils.showToast(ytList[temp].id + " subscribed");
    } else {
      //Utils.showToast('Update Token');
    }
    setState(() {});
    print(response.statusCode.toString());
  }

  Future<void> getChannelData() async {
    print('id: ' + Service.channelsList[i].channelId);
    for (int i = 0; i < Service.channelsList.length; i++) {
      var url =
          'https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=${Service.channelsList[i].channelId}&key=${Service.key}';
      var response = await http.get(url);
      print('Response status: ${response.statusCode}');

      var data = jsonDecode(response.body);
      print(data['items'][0]['statistics']);
      print(data['items'][0]['statistics']['subscriberCount']);

      YtChannel yChannel = YtChannel();
      print(_subscribers);
      yChannel.thumbnail =
          data['items'][0]['snippet']['thumbnails']['high']['url'];
      yChannel.id = data['items'][0]['snippet']['title'];
      yChannel.subscribers = data['items'][0]['statistics']['subscriberCount'];

      ytList.add(yChannel);
    }

    setState(() {
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Service.channelsList.isEmpty
          ? Center(
              child: Text(
                'No Channels Right now',
                style: TextStyle(fontSize: 14.0),
              ),
            )
          : !isLoaded
              ? Center(child: CircularProgressIndicator())
              : Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                String url =
                                    'https://www.youtube.com/channel/${Service.channelsList[i].channelId}';
                                _launchURL(url);
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: ytList[i].thumbnail,
                                        placeholder: (context, url) =>
                                            CircularProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 15),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          //image: Image.network(yChannel.thumbnail),
                                          image:
                                              AssetImage("assets/youtube.jpg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        "${ytList[i].id}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
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
                                  Switch(
                                      inactiveThumbColor:
                                          KSecondaryColor.withOpacity(0.5),
                                      activeColor: KSecondaryColor,
                                      inactiveTrackColor:
                                          KSecondaryColor.withOpacity(0.4),
                                      value: isAutoPlay,
                                      onChanged: (value) {
                                        setState(() {
                                          isAutoPlay = !isAutoPlay;
                                          getChannelData();
                                        });
                                      }),
                                ],
                              ),
                              Center(
                                child: AutoSizeText(
                                  "Subscribe to your channel &  get bonus, DO NOT unsubscribe or cancel like, We will block your account if you unsubscribe any channel",
                                  style: TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                ),
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
                                subscribeChannel();

                                int temp = i + 1;
                                if (temp == Service.channelsList.length) {
                                  Utils.showToast('No more Videos');
                                  return;
                                }

                                i++;
                              },
                              child: FittedBox(
                                  child: Text(
                                "SUBSCRIBE ( +${ytList[i].subscribers} )",
                                style: TextStyle(
                                    fontSize: 10, color: KPrimaryColor),
                              )),
                            ),
                            FlatButton(
                              color: KSecondaryColor,
                              minWidth: Get.width * 0.4,
                              onPressed: () {
                                setState(() {
                                  int temp = i + 1;
                                  if (temp == Service.channelsList.length) {
                                    Utils.showToast('No more Videos');
                                    return;
                                  } else
                                    i++;
                                });
                              },
                              child: FittedBox(
                                  child: Text(
                                "SEE NEXT",
                                style: TextStyle(
                                    fontSize: 10, color: KPrimaryColor),
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
