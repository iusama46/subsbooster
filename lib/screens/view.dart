import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constant.dart';

class ViewScreen extends StatefulWidget {
  @override
  _ViewScreenState createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  int currentVideo = 0;
  YoutubePlayerController _controller;
  bool isAutoPlay = true;
  int count = 0;
  Timer _timer;
  int _start;
  User user;
  var _firebaseUserRef = FirebaseDatabase().reference().child('videos');
  int tempPoints=0;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (Service.videosList.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: Service.videosList[currentVideo].videoId.toString(),
        flags: YoutubePlayerFlags(
          disableDragSeek: true,
          autoPlay: true,
          hideControls: true,
          endAt: int.parse(Service.videosList[currentVideo].duration),
          mute: false,
        ),
      )..addListener(listener);

      tempPoints = int.parse(Service.videosList[currentVideo].duration) +
          int.parse(Service.videosList[currentVideo].views);
      _start = int.parse(Service.videosList[currentVideo].duration) + 2;
    }

    //Utils.showToast('Videos: ${Service.videosList.length.toString()}');

    loadCounter();
  }

  loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      count = prefs.getInt('count');
      if (count == null) count = 0;
      print(count);
    } catch (e) {
      count = 0;
    }
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setInt('count', count);
    });
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          //setState(() {
          print('done');
          timer.cancel();
          //});
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  bool _isPlayerReady = false;
  bool isNext = false;

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;

        if (_controller.value.position.inSeconds > 0 && isNext) {
          startTimer();
          isNext = false;
        }
      });
    }
  }

  @override
  void dispose() {
    if (_timer != null) _timer.cancel();

    if (_controller != null) _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    if (_timer != null) _timer.cancel();
    if (_controller != null) _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
        ),
        padding: EdgeInsets.only(top: 20),
        child: Service.videosList.isEmpty
            ? Center(
                child: Text(
                  'No videos right now',
                  style: TextStyle(fontSize: 15.0),
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: YoutubePlayer(
                      onEnded: (data) {
                        if (_timer != null) _timer.cancel();

                        int index = currentVideo;

                        _firebaseUserRef
                            .child(Service.videosList[index].id)
                            .update({
                          'completed': Service.videosList[index].completed + 1,
                        }).whenComplete(() {
                          _firebaseUserRef
                              .child(Service.videosList[index].id)
                              .child('viewed')
                              .update({user.uid: user.uid}).whenComplete(() {
                            Service.firebaseUserRef.child(user.uid).update({
                              'points': Service.points + tempPoints
                            }).whenComplete(() => Service.points += tempPoints);
                          });
                        });
                        print('i f:' + currentVideo.toString());
                        if (isAutoPlay) {
                          count++;
                          tempPoints = int.parse(Service.videosList[currentVideo].duration) +
                              int.parse(Service.videosList[currentVideo].views);
                          _incrementCounter();

                        }
                        print(data.duration);
                        print('val: ' + currentVideo.toString());
                        isNext = true;
                        if (isAutoPlay) {
                          int temp = currentVideo + 1;
                          if (temp == Service.videosList.length) {
                            Utils.showToast('No more Videos');
                            return;
                          }
                          print('val: ' + currentVideo.toString());

                          currentVideo++;
                          if (currentVideo < Service.videosList.length) {
                            _controller.load(
                                Service.videosList[currentVideo].videoId,
                                startAt: 0,
                                endAt: int.parse(
                                    Service.videosList[currentVideo].duration));
                            print('started' + currentVideo.toString());
                            setState(() {
                              _start = int.parse(Service
                                      .videosList[currentVideo].duration) +
                                  2;
                            });
                          } else {
                            isNext = false;
                            Utils.showToast('No more Videos left');
                          }
                        }
                        print('val: ' + currentVideo.toString());
                      },
                      showVideoProgressIndicator: true,
                      controller: _controller,
                      liveUIColor: Colors.amber,
                      onReady: () {
                        _isPlayerReady = true;
                        setState(() {
                          startTimer();
                        });
                        print("ready player");
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Auto Play (Daily Limit : ${count.toString()}/250)",
                        style: TextStyle(fontSize: 10),
                      ),
                      Switch(
                          inactiveThumbColor: Colors.grey,
                          activeColor: KSecondaryColor,
                          inactiveTrackColor: Colors.grey.withOpacity(0.4),
                          activeTrackColor: KSecondaryColor.withOpacity(0.4),
                          value: isAutoPlay,
                          onChanged: (value) {
                            isAutoPlay = !isAutoPlay;
                            setState(() {});
                          }),
                    ],
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesome.clock_o,
                          size: 35,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "$_start",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 40,
                            child: VerticalDivider(
                              color: KSecondaryColor,
                              thickness: 2,
                              width: 10,
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Icon(
                                FontAwesome.dollar,
                                size: 12,
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          Service.videosList[currentVideo].points.toString() !=
                                  null
                              ? tempPoints.toString()
                              : '30',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FlatButton(
                    color: KSecondaryColor,
                    minWidth: Get.width,
                    onPressed: () {
                      _timer.cancel();
                      int temp = currentVideo + 1;
                      if (temp == Service.videosList.length) {
                        Utils.showToast('No more Videos');
                        return;
                      }

                      currentVideo++;

                      if (currentVideo < Service.videosList.length) {
                        isNext = true;

                        _controller.load(
                            Service.videosList[currentVideo].videoId,
                            startAt: 0,
                            endAt: int.parse(
                                Service.videosList[currentVideo].duration));
                        tempPoints = int.parse(Service.videosList[currentVideo].duration) +
                            int.parse(Service.videosList[currentVideo].views);
                        print('started' + currentVideo.toString());
                        setState(() {
                          _start = int.parse(
                                  Service.videosList[currentVideo].duration) +
                              2;
                        });
                      } else {
                        Utils.showToast('No more Videos left');
                      }
                    },
                    child: FittedBox(
                        child: Text(
                      "SEE NEXT",
                      style: TextStyle(fontSize: 10, color: KPrimaryColor),
                    )),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
      ),
    );
  }
}
