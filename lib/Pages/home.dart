import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:first_flutter_app/Setup/MyImage.dart';
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
  //_HomeState createState() => _HomeState();
  createState() => FirestoreSlideshowState();

  final User credentials;

  const Home({Key key, @required this.credentials}) : super(key: key);
}

class FirestoreSlideshowState extends State<Home> {
  final PageController ctrl = PageController(viewportFraction: 0.8);
  final FirebaseFirestore db = FirebaseFirestore.instance;
  DocumentReference sightingRef =
      FirebaseFirestore.instance.collection('images').doc();

  List<File> _images = [];
  List<MyImage> slides = [];
  String activeTag = 'favorites';

  int currentPage = 0;

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getVideo(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _images.add(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });

    if (pickedFile != null) {
      await saveImages(_images, sightingRef);
    }
  }

  Future<void> saveImages(List<File> _images, DocumentReference ref) async {
     await uploadFile(_images.last);
  }

  Future<String> uploadFile(File _image) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('images/${_image.path.split('/').last}');
    await storageReference.putFile(_image, SettableMetadata(contentType: 'video/mp4'));
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL = fileURL;
      db.collection('stories').add({
        'title': 'alt titlu',
        'img': returnURL,
        'tags': ['favorites', 'cool']
      });
      print('The returned url is: ${returnURL}');
    });
    _queryDb();
    return returnURL;
  }

  @override
  void initState() {
    print('init func');
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
    return PageView.builder(
      controller: ctrl,
      itemCount: slides.length + 1,
      // ignore: missing_return
      itemBuilder: (context, int currentIdx) {
        if (currentIdx == 0) {
          return _buildTagPage();
        } else if (slides.length >= currentIdx) {
          bool active = currentIdx == currentPage;
          print(_images.toString());
          return _buildStoryPage(slides.elementAt(currentIdx - 1), active);
        }
      },
    );
  }

  _queryDb({String tag = 'favorites'}) async {
    slides.clear();
    // Make a Query
    Query query = db.collection('stories').where('tags', arrayContains: tag);

    var snapshot = await db.collection("stories").get();
    for (var s in snapshot.docs) {
      print("title in query: ${s['title']}");
      var image = new MyImage(s['img'], s['title']);
      print(image);
      slides.add(image);
    }
    //slides = query.snapshots().map((list) => list.docs.map((doc) => doc.data));
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
                  color: Colors.pink,
                  decoration: TextDecoration.none)),
          RaisedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
            child: Text('Sign out'),
          ),
        ]),
        // ignore: deprecated_member_use
        Text(
          'Your PHOTOS',
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.none),
        ),
        Text('FILTER by tag:',
            style: TextStyle(
                fontSize: 25,
                color: Colors.pink,
                decoration: TextDecoration.none)),
        _buildButton('favorites'),
        _buildButton('happy'),
        _buildButton('sad'),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          RawMaterialButton(
            fillColor: Theme.of(context).accentColor,
            child: Icon(
              Icons.add_photo_alternate_rounded,
              color: Colors.white,
            ),
            elevation: 8,
            onPressed: () {
              getImage(true);
            },
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
          ),
          RawMaterialButton(
            fillColor: Theme.of(context).accentColor,
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white,
            ),
            elevation: 8,
            onPressed: () {
              getImage(false);
            },
            padding: EdgeInsets.all(20),
            shape: CircleBorder(),
          )
        ]),
      ],
    ));
  }

  _buildButton(tag) {
    Color color = tag == activeTag ? Colors.purple : Colors.white;
    return FlatButton(
        color: color,
        child: Text('#$tag'),
        onPressed: () => _queryDb(tag: tag));
  }

  _buildStoryPage(MyImage data, bool active) {
    final double blur = active ? 30 : 0;
    final double offset = active ? 20 : 0;
    final double top = active ? 100 : 200;

    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        curve: Curves.easeOutQuint,
        margin: EdgeInsets.only(top: top, bottom: 50, right: 30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(data.img),
            ),
            boxShadow: [
              BoxShadow(
                  color: Colors.black87,
                  blurRadius: blur,
                  offset: Offset(offset, offset))
            ]),
        child: Center(
            child: Text(data.title,
                style: TextStyle(fontSize: 40, color: Colors.white))));
  }
}
