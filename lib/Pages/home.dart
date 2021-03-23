import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter_app/Setup/MyVideo.dart';
import 'package:first_flutter_app/Setup/VideoPlayerScreen.dart';
import 'package:first_flutter_app/Setup/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_flutter_app/authentication_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  createState() => FirestoreSlideshowState();

  final User credentials;

  const Home({Key key, @required this.credentials}) : super(key: key);
}

class FirestoreSlideshowState extends State<Home> {
  final PageController ctrl = PageController(viewportFraction: 0.8);
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference sightingRef =
      FirebaseFirestore.instance.collection(STORAGE_FOLDER).doc();

  List<File> _videos = [];
  List<MyVideo> slides = [];
  String activeTag = 'unlabeled';

  int currentPage = 0;

  Future getVideo(bool gallery) async {
    File pickedFile;
    // Let user select video from gallery
    if (gallery) {
      pickedFile = await ImagePicker.pickVideo(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new video
    else {
      pickedFile = await ImagePicker.pickVideo(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _videos.add(File(pickedFile.path));
      } else {
        print('No video selected.');
      }
    });

    if (pickedFile != null) {
      await saveNewVideo(_videos.last);
    }
  }

  Future<void> saveNewVideo(File video) async {
    await uploadNewVideo(video);
  }

  Future<String> uploadNewVideo(File video) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$STORAGE_FOLDER/${video.path.split('/').last}');

    await storageReference.putFile(
        video, SettableMetadata(contentType: 'video/mp4'));

    print('File Uploaded');
    String returnedURL;

    await storageReference.getDownloadURL().then((fileURL) {
      returnedURL = fileURL;
      db.collection(COLLECTION_NAME).add({
        'url': returnedURL,
        'uploadDate': Timestamp.now(),
        'tags': [DEFAULT_LABEL, 'all'],
        'labeled': false
      });
      print('The returned url is: $returnedURL');
    });

    _queryDb();
    return returnedURL;
  }

  @override
  void initState() {
    _queryDb();
    ctrl.addListener(() {
      int next = ctrl.page.round();
      if (currentPage != next) {
        setState(() {
          currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build done with ${slides.length} slides');

    return PageView.builder(
      controller: ctrl,
      itemCount: slides.length + 1,
      // ignore: missing_return
      itemBuilder: (context, int currentIdx) {
        if (currentIdx == 0) {
          return _buildTagPage();
        } else if (slides.length >= currentIdx) {
          bool active = currentIdx == currentPage;
          print(_videos.toString());
          return _buildStoryPage(slides.elementAt(currentIdx - 1), active);
        }
      },
    );
  }

  _queryDb({String tag = 'unlabeled'}) async {
    slides.clear();

    var snapshot = await db
        .collection(COLLECTION_NAME)
        .where('tags', arrayContains: tag)
        .get();

    for (var s in snapshot.docs) {
      var video = new MyVideo(s['url'], s['uploadDate'], s['labeled']);
      print('video from query for: $video');
      slides.add(video);
    }

    print('slides: ${slides.toString()}');

    // Update the active tag
    setState(() {
      activeTag = tag;
    });
  }

  _buildTagPage() {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('Hello, ${widget.credentials.email} !',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: bone,
                  decoration: TextDecoration.none)),
          RaisedButton(
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
            color: coolGrey,
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text('Sign out'),
          ),
        ]),
        // ignore: deprecated_member_use
        Text(
          'Swipe left to see the tricks',
          style: TextStyle(
              color: brickRed,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none),
        ),
        Text('FILTER by tag:',
            style: TextStyle(
                fontSize: 25,
                color: brickRed,
                decoration: TextDecoration.none)),
        _buildButton('unlabeled'),
        _buildButton('all'),
        _buildButton('ollie'),
        _buildButton('slide'),
        _buildButton('fail'),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          RawMaterialButton(
            fillColor: coolGrey,
            child: Icon(
              Icons.add_photo_alternate_rounded,
              color: dutchWhite,
            ),
            elevation: 8,
            onPressed: () {
              getVideo(true);
            },
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
          ),
          RawMaterialButton(
            fillColor: coolGrey,
            child: Icon(
              Icons.add_a_photo,
              color: dutchWhite,
            ),
            elevation: 8,
            onPressed: () {
              getVideo(false);
            },
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
          )
        ]),
      ],
    ));
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? brickRed : bone;
    return FlatButton(
        color: color,
        child: Text('#$tag'),
        onPressed: () => _queryDb(tag: tag));
  }

  _buildStoryPage(MyVideo data, bool active) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 150 : 200;
    final double bottom = active ? 150 : 50;
    final double right = 30;
    final double borderWidth = active ? 10.0 : 15.0;

    final String day = data.uploadDate.toDate().day.toString();
    final String month = data.uploadDate.toDate().month.toString();
    final String year = data.uploadDate.toDate().year.toString();
    final String hour = data.uploadDate.toDate().hour < 10 ? '0' + data.uploadDate.toDate().hour.toString() : data.uploadDate.toDate().hour.toString();
    final String minute = data.uploadDate.toDate().minute.toString();
    final String labeled =
        data.labeled ? 'been labled!' : 'has not been yet labeled :(';

    return AnimatedContainer(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: active ? coolGrey : brickRed,
                width: borderWidth),
            boxShadow: [
              BoxShadow(
                  color: Colors.black87,
                  blurRadius: blur,
                  offset: Offset(offset, offset))
            ]),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: bottom, right: right),
        child: Column(children: [
          Text('> This video has been uploaded on ' + day +'/' + month +'/'+year + ' at '+hour+':'+minute +'\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: brickRed,
                  decoration: TextDecoration.none)),
          Text('> This video has ' + labeled + '\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: brickRed,
                  decoration: TextDecoration.none)),
          Expanded(
              child: VideoPlayerScreen(
                  url: data.url, active: active ? true : false))
        ]));
  }
}
