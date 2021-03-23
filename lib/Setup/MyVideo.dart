import 'package:cloud_firestore/cloud_firestore.dart';

class MyVideo {
  String url;
  Timestamp uploadDate;
  //List<String> tags;
  bool labeled;

  MyVideo(String url, Timestamp dateTime,  bool labeled){
    this.url = url;
    this.uploadDate = dateTime;
    //this.tags = labels;
    this.labeled = labeled;
  }

  @override
  String toString() {
    return 'MyVideo{url: $url, uploadDate: $uploadDate, labeled: $labeled}';
  }
}