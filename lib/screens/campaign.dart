import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:subsbooster/constant.dart';
import 'package:subsbooster/models/video.dart';
import 'package:subsbooster/screens/showDialogueBox.dart';

class CampaignScreen extends StatefulWidget {
  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  var _firebaseUserRef;

  var user = FirebaseAuth.instance.currentUser;
  List<VideoData> videoList = List<VideoData>();

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  Stream one;

  Stream two;
  Stream three;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseDatabase()
        .reference()
        .child('videos')
        .orderByChild("uId")
        .equalTo(user.uid)
        .once()
        .then((value) {
      Map data = value.value;
      List items = [];
      data.forEach((index, data) => items.add({"key": index, ...data}));

      for (int i = 0; i < items.length; i++) {
        VideoData data = VideoData(
          title: items[i]['videoId'],
          icon: FontAwesome.youtube_play,
          target: items[i]['views'],
          completed: items[i]['completed'],
        );
        videoList.add(data);

        print(data.title);
      }
      setState(() {});
    });

    FirebaseDatabase()
        .reference()
        .child('likes')
        .orderByChild("uId")
        .equalTo(user.uid)
        .once()
        .then((value) {
      Map data = value.value;
      List items = [];
      data.forEach((index, data) => items.add({"key": index, ...data}));

      for (int i = 0; i < items.length; i++) {
        VideoData data = VideoData(
          title: items[i]['videoId'],
          icon: FontAwesome.thumbs_up,
          target: items[i]['views'],
          completed: items[i]['completed'],
        );
        videoList.add(data);

        print(data.title);
      }
      setState(() {});
    });

    FirebaseDatabase()
        .reference()
        .child('channels')
        .orderByChild("uId")
        .equalTo(user.uid)
        .once()
        .then((value) {
      Map data = value.value;
      List items = [];
      data.forEach((index, data) => items.add({"key": index, ...data}));

      for (int i = 0; i < items.length; i++) {
        VideoData data = VideoData(
          title: items[i]['channelId'],
          icon: FontAwesome.user_plus,
          target: items[i]['subscribers'],
          completed: items[i]['completed'],
        );
        videoList.add(data);

        print(data.title);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:videoList.length==0? noUser(context): Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              return TileItem(
                data: videoList[index],index: index+1,
              );
            }),
      ),
      floatingActionButton: Container(
        child: FabCircularMenu(
            animationDuration: Duration(microseconds: 1000),
            fabSize: 55,
            fabOpenColor: KSecondaryColor,
            fabCloseColor: KSecondaryColor,
            fabOpenIcon: Icon(
              Icons.add,
              color: KPrimaryColor,
            ),
            fabCloseIcon: Icon(
              Icons.close,
              color: KPrimaryColor,
            ),
            ringColor: KPrimaryColor,
            fabMargin: EdgeInsets.only(bottom: 10, right: 20),
            ringDiameter: 320.0,
            ringWidth: 50.0,
            children: <Widget>[
              Container(),
              GestureDetector(
                child: Container(
                    margin: EdgeInsets.only(left: 100, top: 20),
                    padding: EdgeInsets.only(left: 5),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: KSecondaryColor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      FontAwesome.user_plus,
                      color: KPrimaryColor,
                    )),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ShowDialogueBox(3);
                    },
                  );
                },
              ),
              GestureDetector(
                  child: Container(
                      margin: EdgeInsets.only(left: 30, top: 20, bottom: 5),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: KSecondaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        FontAwesome.thumbs_up,
                        color: KPrimaryColor,
                      )),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowDialogueBox(2);
                      },
                    );
                  }),
              GestureDetector(
                  child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.only(left: 5),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: KSecondaryColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        FontAwesome.play,
                        color: KPrimaryColor,
                      )),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return ShowDialogueBox(1);
                      },
                    );
                  }),
            ]),
      ),
    );
  }
  Widget noUser(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesome.home,
            size: 60,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "No Campaign",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Your campaign appear here. Click add button to create campaign to get subscribers for your channel",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

}

class TileItem extends StatelessWidget {
  final VideoData data;
  final int index;

  TileItem({this.data, this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: Icon(data.icon),

            //title: Text(' videoId: ' + data.title),
            title: Text(
                '${index.toString()}. Campaign: ${data.completed.toString()}/${data.target.toString()}'),
          ),
          Divider(
            thickness: 2.0,
          ),
        ],
      ),
    );
  }


}

/*
StreamBuilder(
stream: Rx.merge([one, two]),
builder: (context, snap) {
if (!snap.hasData ||
snap.hasError ||
snap.data.snapshot.value == null) {
return Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
FontAwesome.home,
size: 60,
),
SizedBox(
height: 10,
),
Text(
"No Campaign",
style: TextStyle(fontSize: 16),
),
SizedBox(
height: 10,
),
Text(
"Your campaign appear here. Click add button to create campaign to get subscribers for your channel",
style: TextStyle(fontSize: 12),
textAlign: TextAlign.center,
),
],
),
);
} else {
print(snap.data.snapshot.value.toString());
Map data = snap.data.snapshot.value;
List item = [];

data.forEach((index, data) => item.add({"key": index, ...data}));

return ListView.builder(
itemCount: item.length,
itemBuilder: (context, index) {
// print('kk' + item.toString());
// print('kk' + item[index]['key']);
// print('kk' + item[index]['videoId']);

return TileItem();
},
);
}
},
),*/

/*

return Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(
FontAwesome.home,
size: 60,
),
SizedBox(
height: 10,
),
Text(
"No Campaign",
style: TextStyle(fontSize: 16),
),
SizedBox(
height: 10,
),
Text(
"Your campaign appear here. Click add button to create campaign to get subscribers for your channel",
style: TextStyle(fontSize: 12),
textAlign: TextAlign.center,
),
],
),
);*/
