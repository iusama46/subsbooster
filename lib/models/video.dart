import 'package:firebase_database/firebase_database.dart';

class YVideo {
  dynamic id;
  dynamic title;
  dynamic thumbnail;

  dynamic like;

  YVideo({this.id, this.title, this.thumbnail, this.like});
}

class YChannel {
  dynamic id;
  dynamic channelId;
  dynamic points;
  dynamic target;
  dynamic userId;
  dynamic completed;

  YChannel(
      {this.id,
      this.channelId,
      this.points,
      this.target,
      this.userId,
      this.completed});
}

class CVideo {
  dynamic id;
  dynamic videoId;
  dynamic points;
  dynamic duration;
  dynamic userId;
  dynamic views;
  dynamic completed;

  CVideo(
      {this.id,
      this.videoId,
      this.points,
      this.duration,
      this.userId,
      this.completed,
      this.views});
}

class Service {
  static final key = 'AIzaSyBG1WXVwW16qWwDS5JyVhlm-9P__WQBnPw';
  static List<CVideo> videosList = List<CVideo>();
  static List<CVideo> likeVideosList = List<CVideo>();
  static List<YChannel> channelsList = List<YChannel>();
  static int points = 450;
  static var firebaseUserRef = FirebaseDatabase().reference().child('users');
}

class VideoData {
  dynamic title;
  dynamic leading;
  dynamic subTitle;
  dynamic icon;
  dynamic completed;
  dynamic target;

  VideoData(
      {this.title,
      this.leading,
      this.subTitle,
      this.icon,
      this.completed,
      this.target});
}
