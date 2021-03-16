import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


/// Created by Ussama Iftikhar on 16-Mar-2021.
/// Email iusama46@gmail.com
/// Email iusama466@gmail.com
/// Github https://github.com/iusama46
///
class CampaignStart extends StatefulWidget {
  final videoId;
  final id;

  CampaignStart({@required this.videoId, this.id});

  @override
  _CampaignStartState createState() => _CampaignStartState();
}

class _CampaignStartState extends State<CampaignStart> {
  YoutubePlayerController _controller;

  var _firebaseRef = FirebaseDatabase().reference();
  var _firebaseUserRef = FirebaseDatabase().reference().child('users');
  User user;
  var numberOfViews = '50';
  var timeRequired = '30';
  int amount = 1800;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId == null ? 'miss21Qm4bI' : widget.videoId,
      flags: YoutubePlayerFlags(
          autoPlay: true,
          loop: false,
          mute: false,
          controlsVisibleAtStart: true),
    );

    user = FirebaseAuth.instance.currentUser;
  }

  void getTotal() {
    var temp1 = int.parse(timeRequired);
    assert(temp1 is int);
    var temp2 = int.parse(numberOfViews);
    assert(temp2 is int);
    amount = temp2 * temp1;
    print(amount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaign'),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressColors: ProgressBarColors(
                playedColor: KSecondaryColor,
                handleColor: KSecondaryColor,
              ),
              progressIndicatorColor: KSecondaryColor,
              liveUIColor: Colors.amber,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Text(
                    'Order Settings',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.004,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.id == 1
                              ? 'Number of Views'
                              : 'Number of Likes',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            elevation: 0,
                            dropdownColor: KPrimaryColor,
                            value: numberOfViews,
                            items: <String>['50', '100', '200', '500']
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {
                              numberOfViews = _;
                              getTotal();
                            },
                            focusColor: Colors.lightBlue,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.0005,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time Required(seconds)',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            elevation: 0,
                            isDense: true,
                            dropdownColor: KPrimaryColor,
                            value: timeRequired,
                            items: <String>['30', '45', '60', '90', '150']
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(fontSize: 18.0),
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {
                              timeRequired = _;
                              getTotal();
                            },
                            focusColor: Colors.lightBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: MediaQuery.of(context).size.height * 0.006,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total Cost',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      amount.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    color: KSecondaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    onPressed: () {
                      setState(() {
                        print(amount);
                      });
                    },
                    //onPressed: function,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlatButton(
                height: MediaQuery.of(context).size.height * 0.058,
                minWidth: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  'Add Campaign',
                  style: TextStyle(color: Colors.white),
                ),
                color: KSecondaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                onPressed: () {

                  if(amount>Service.points){
                    Utils.showToast('You don'+'t have enough points');
                    return;
                  }
                  CVideo cvideo = CVideo(
                      id: '123',
                      //videoId: 'widget.videoId',
                      videoId: widget.videoId,
                      points: amount,
                      views: numberOfViews,
                      duration: timeRequired,
                      userId: user.uid);

                  var temp = widget.id == 1 ? 'videos' : 'likes';
                  _firebaseRef.child(temp).push().set({
                    "uId": user.uid,
                    'duration': cvideo.duration,
                    'points': cvideo.points,
                    'videoId': cvideo.videoId,
                    'views': cvideo.views,
                    'completed':0
                  }).whenComplete(() {
                    _firebaseUserRef.child(user.uid).child(temp).push().set({
                      'videoId': cvideo.videoId,
                    }).whenComplete(() {
                      Utils.showToast('Campaign added');
                      Navigator.pop(context);
                    });
                  });
                  print('added');
                },
                //onPressed: function,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
