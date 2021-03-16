import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/screens/campaign_start_screen.dart';
import 'package:subsbooster/screens/campaign_start_screen_channel.dart';
import 'package:subsbooster/utils/utils.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class ShowDialogueBox extends StatelessWidget {

  final id;

  ShowDialogueBox(this.id);

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Expanded(child: Container()),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: Container(
              width: Get.width * 0.9,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    width: Get.width,
                    color: KSecondaryColor,
                    child: Text(
                      id==3?"Add your channel"
                      :"Add your video",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: KPrimaryColor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: Get.width * 0.6,
                        child: TextFormField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 0),
                            hintText: id==3?'Enter your channel link here':"Enter your video link here",
                            hintStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            focusColor: KSecondaryColor,
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: KSecondaryColor, width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: KSecondaryColor, width: 2),
                            ),
                          ),
                          cursorColor: KSecondaryColor,
                        ),
                      ),
                      FlatButton(
                        color: KSecondaryColor,
                        minWidth: 70,
                        onPressed: () {


                          if (textEditingController.text
                              .toString()
                              .trim()
                              .isEmpty) {
                            if(id==3)
                              Utils.showToast('Enter correct channel Url');
                            else
                              Utils.showToast('Enter correct video Url');
                            return;
                          }

                          if(id==3){
                            try {
                              var url = textEditingController.text.toString()
                                  .trim();
                              url = url.replaceAll(
                                  "https://www.youtube.com/channel/", "");
                              url = url.replaceAll(
                                  "https://m.youtube.com/channel/", "");
                              url =
                                  url.replaceAll("https://youtube.com/c/", "");

                              print('this is ' + url);
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CampaignStartChannel(
                                      channelId: url,
                                      id: id,
                                    )),
                              ).then((value) {FocusScope.of(context).requestFocus(FocusNode()); Navigator.pop(context);});
                            }catch(e){
                              Utils.showToast('Url parsing Failed');
                            }
                            return;
                          }
                          var videoId;
                          try {

                            videoId = YoutubePlayer.convertUrlToId(
                                textEditingController.text.toString().trim());
                            Utils.showToast('videoId ' + videoId);
                            FocusScope.of(context).requestFocus(FocusNode());
                            print('this is ' + videoId);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CampaignStart(
                                        videoId: videoId,
                                    id: id,
                                      )),
                            ).then((value) {
                              FocusScope.of(context).requestFocus(FocusNode());Navigator.pop(context);});
                          } on Exception catch (exception) {
                            Utils.showToast('Unable to parse URL');
                            print('exception');
                          } catch (error) {
                            print('catch error');
                            Utils.showToast('Unable to parse URL');
                          }
                        },
                        child: FittedBox(
                            child: Text(
                          "ADD",
                          style: TextStyle(fontSize: 10, color: KPrimaryColor),
                        )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.black,
                    endIndent: 5,
                    indent: 5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      id==3?'How to get link : open your channel on YT -> share button -> copy link':
                      "How to get link : open your video on YT -> share button -> copy link",
                      style: TextStyle(color: KGreyColor, fontSize: 12),
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
}
