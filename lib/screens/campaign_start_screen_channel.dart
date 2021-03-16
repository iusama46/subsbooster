import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/models/channel.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/utils/utils.dart';

/// Created by Ussama Iftikhar on 17-Mar-2021.
/// Email iusama46@gmail.com
/// Email iusama466@gmail.com
/// Github https://github.com/iusama46

class CampaignStartChannel extends StatefulWidget {
  final channelId;
  final id;

  CampaignStartChannel({@required this.channelId, this.id});

  @override
  _CampaignStartChannelState createState() => _CampaignStartChannelState();
}

class _CampaignStartChannelState extends State<CampaignStartChannel> {
  var _firebaseRef = FirebaseDatabase().reference();
  var _firebaseUserRef = FirebaseDatabase().reference().child('users');
  User user;
  var numberOfViews = '50';
  bool isLoaded = false;

  int amount = 500;
  YtChannel yChannel = YtChannel(
      id: 'test',
      subscribers: 0,
      thumbnail: 'http://via.placeholder.com/350x150');

  Future<void> getChannel() async {
    try {
      var url =
          'https://youtube.googleapis.com/youtube/v3/channels?part=snippet%2CcontentDetails%2Cstatistics&id=${widget.channelId}&key=${Service.key}';

      var response = await http.get(url);
      print('Response status: ${response.statusCode}');
      //print('Response body: ${response.body}');

      var data = jsonDecode(response.body);
      print(data['items'][0]['statistics']);
      print(data['items'][0]['statistics']['subscriberCount']);

      ///1000;

      yChannel.thumbnail =
          data['items'][0]['snippet']['thumbnails']['high']['url'];
      yChannel.id = data['items'][0]['snippet']['title'];
      yChannel.subscribers = data['items'][0]['statistics']['subscriberCount'];
      print(data['items'][0]['snippet']['thumbnails']['high']['url']);
      print(data['items'][0]['snippet']['title']);

      setState(() {
        isLoaded = true;
      });
    } catch (e) {
      Utils.showToast('Failed to load');
      Navigator.pop(context);
    }
  }

  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    getChannel();
  }

  void getTotal() {
    var temp2 = int.parse(numberOfViews);
    assert(temp2 is int);
    amount = temp2 * 100;
    print(amount);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Campaign'),
      ),
      body: isLoaded
          ? Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 4.0),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: yChannel.thumbnail.toString(),
                        placeholder: (context, url) =>
                            Image.asset("assets/youtubelike.png"),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      //child: Image.network(yChannel.thumbnail.toString()),
                    ),
                    // decoration: BoxDecoration(
                    //   image: DecorationImage(
                    //     fit: BoxFit.cover,
                    //     image: AssetImage("assets/youtubelike.png"),
                    //   ),
                    // ),
                  ),
                  Text(
                    yChannel.id,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                                'Number of Subscribers',
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
                        if (amount > Service.points) {
                          Utils.showToast('You don' + 't have enough points');
                          return;
                        }
                        _firebaseRef.child('channels').push().set({
                          "uId": user.uid,
                          'channelId': widget.channelId,
                          'points': amount,
                          'subscribers': numberOfViews,
                          'completed': 0
                        }).whenComplete(() {
                          _firebaseUserRef
                              .child(user.uid)
                              .child('channels')
                              .push()
                              .set({
                            'channelId': widget.channelId,
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.

    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
