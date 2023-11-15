import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:identifly/myListing.dart';
import 'package:identifly/profilepage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee/marquee.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyUpload extends StatefulWidget {
  const MyUpload({Key? key}) : super(key: key);

  @override
  _MyUploadState createState() => _MyUploadState();
}

class _MyUploadState extends State<MyUpload> {
  File? uploadimage;
  bool isImageLoaded = false;
  dynamic _bird;
  List birdsList = [];
  String _label = "";
  dynamic _confidence;
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  late TextEditingController _deviceController;

  // Create a reference to the Firestore collection where you want to store the data.
  final CollectionReference birdsCollection = FirebaseFirestore.instance.collection('myBirds');

  String _locationMessage = "";

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadMyModel();
    _getLocation();
    // Initialize controllers with default values or existing values.
    _nameController = TextEditingController(text: 'unknown');
    _locationController = TextEditingController(text: 'unknown');
    _dateController = TextEditingController(text: 'unknown');
    _timeController = TextEditingController(text: 'unknown');
    _deviceController = TextEditingController(text: 'unknown');
  }



  // void _addBirdToFirestore() async {
  //   // Create a new document in the collection.
  //   final DocumentReference myBirdsDocument = birdsCollection.doc("anandarul47@gmail.com");
  //   // Await the Future<DocumentSnapshot<Object?>> object.
  //   final DocumentSnapshot<Object?> documentSnapshot = await myBirdsDocument.get();
  //   // Check if the document exists.
  //   if (documentSnapshot.exists) {
  //
  //     // Get the user's birds array.
  //     final List<dynamic> birdsArray = documentSnapshot['birds'];
  //
  //     // Add the new bird to the array.
  //     birdsArray.add({
  //       'label': _label,
  //       'image': "uploadimage",
  //       'location': 'unknown',
  //       'date': DateTime.now().toString().substring(0, 11),
  //       'time': DateTime.now().toString().substring(11, 19),
  //       'device': 'Oneplus 8',
  //     });
  //
  //     // Set the updated birds array on the document.
  //     myBirdsDocument.update({'birds': birdsArray});
  //   } else {
  //     // The document does not exist, so create it.
  //     myBirdsDocument.set({
  //       'username': 'anandarul47@gmail.com',
  //       'birds': [],
  //     });
  //   }
  // }



  Future<void> _addBirdToFirestore() async {
    // Create a new document in the collection.
    final DocumentReference myBirdsDocument = birdsCollection.doc("anandarul47@gmail.com");
    // Await the Future<DocumentSnapshot<Object?>> object.
    final DocumentSnapshot<Object?> documentSnapshot = await myBirdsDocument.get();
    // Check if the document exists.
    if (documentSnapshot.exists) {
      // Get the user's birds array.
      final List<dynamic> birdsArray = documentSnapshot['birds'];

      // Upload the image to Firebase Storage and get the download URL.
      String imageDownloadURL = await _uploadImageToStorage();

      // Add the new bird to the array.
      birdsArray.add({
        'label': _label,
        'image': imageDownloadURL,
        'location': 'unknown',
        'date': DateTime.now().toString().substring(0, 11),
        'time': DateTime.now().toString().substring(11, 19),
        'device': 'Oneplus 8',
      });

      // Set the updated birds array on the document.
      myBirdsDocument.update({'birds': birdsArray});
    } else {
      // The document does not exist, so create it.
      myBirdsDocument.set({
        'username': 'anandarul47@gmail.com',
        'birds': [],
      });
    }
  }

  Future<String> _uploadImageToStorage() async {
    try {
      if (uploadimage != null) {
        File imageFile = uploadimage!;

        // Create a reference to the Firebase Cloud Storage bucket
        Reference storageReference = FirebaseStorage.instance.ref().child('images/${DateTime.now().toString()}');

        // Upload the file to Firebase Cloud Storage
        await storageReference.putFile(imageFile);

        // Get the download URL
        String downloadURL = await storageReference.getDownloadURL();

        return downloadURL;
      } else {
        return '';
        // Handle the case where uploadimage is null
        print('Upload image is null.');
      }
    } catch (e) {
      print('Error uploading image to Firestore: $e');
      return ''; // Handle error as needed
    }
  }

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _locationMessage =
        "${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      print(e);
      setState(() {
        _locationMessage = "Error getting location";
      });
    }
  }

  loadMyModel() async {
    var result = await Tflite.loadModel(
        labels: "assets/labels.txt", model: "assets/model_unquant.tflite");

    print("resultant after loading model: $result");
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _bird = res;
      _label = _bird[0]["label"].substring(2);
      _confidence = _bird[0]["confidence"] * 100.0;
    });
    print(_bird);
  }

  void clickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        uploadimage = File(pickedImage.path);
      });
    }
  }

  void chooseImage() async {
    var pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        uploadimage = File(pickedImage.path);
        isImageLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xff191919),
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              Spacer(),
              Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/2219/2219694.png") //Image.asset("gov.png",)
                  ),
              Text(
                "Identi",
                style: TextStyle(color: const Color(0xff75C2F6), fontSize: 30),
              ),
              Text(
                "Fly",
                style: TextStyle(color: const Color(0xffFFBE0F), fontSize: 30),
              ),
              Spacer(),
            ],
          ),
          backgroundColor: const Color(0xff2D4263),
        ),
        body: Container(
          height: double.infinity,
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, //content alignment to center
            verticalDirection: VerticalDirection.down,
            children: [
              // Spacer(),
              // Text("Upload Bird Image", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 20),),
              // SizedBox(height: 20,),
              isImageLoaded
                  ? Container(
                      margin: EdgeInsets.all(20),
                      height: MediaQuery.of(context).size.width * 0.5,
                      width: MediaQuery.of(context).size.width * 0.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                              image: FileImage(
                                  File(uploadimage?.path ?? "assets/1.jpeg")),
                              fit: BoxFit.contain)),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          primary: Colors.white12,
                        ),
                        onPressed: () {
                          chooseImage();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.width * 0.5,
                          width: MediaQuery.of(context).size.width * 0.7,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            image: DecorationImage(
                              image: AssetImage("assets/attach.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
              Container(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 10.0,
                    primary: const Color(0xff2D4263),
                  ),
                  onPressed: () async {
                    await applyModelOnImage(uploadimage!);
                    setState(() {
                      _nameController.text = _label;
                      _locationController.text = _locationMessage;
                      _nameController.text = _label;
                    });
                  },
                  icon: Icon(Icons.search_rounded),
                  label: Text("discover"),
                  //color: Colors.deepOrangeAccent,
                  //colorBrightness: Brightness.dark,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              _bird != null
                  ? Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "{\n\n",
                                    style: TextStyle(
                                      color: const Color(0xffADC4CE),
                                      fontSize: 25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildEditableField("name", _nameController),
                            _buildEditableField("location", _locationController),
                            _buildEditableField("date", _dateController),
                            _buildEditableField("time", _timeController),
                            _buildEditableField("device", _deviceController),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "\n}",
                                      style: TextStyle(
                                          color: const Color(0xffADC4CE),
                                          fontSize: 25)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "{\n\n",
                                      style: TextStyle(
                                          color: const Color(0xffADC4CE),
                                          fontSize: 25)),
                                ],
                              ),
                            ),
                            _buildEditableField("name", _nameController),
                            _buildEditableField("location", _locationController),
                            _buildEditableField("date", _dateController),
                            _buildEditableField("time", _timeController),
                            _buildEditableField("device", _deviceController),
                            // RichText(
                            //   text: TextSpan(
                            //     children: <TextSpan>[
                            //       TextSpan(
                            //           text: '\t   \t"name" :',
                            //           style: TextStyle(
                            //               color: const Color(0xffADC4CE),
                            //               fontSize: 25)),
                            //       TextSpan(
                            //           text: '   unknown',
                            //           style: TextStyle(
                            //               color: const Color(0xff3A98B9),
                            //               fontSize: 25)),
                            //     ],
                            //   ),
                            // ),
                            // RichText(
                            //   text: TextSpan(
                            //     children: <TextSpan>[
                            //       TextSpan(
                            //           text: '\t   \t"location" :',
                            //           style: TextStyle(
                            //               color: const Color(0xffADC4CE),
                            //               fontSize: 25)),
                            //       TextSpan(
                            //           text: _locationMessage,
                            //           style: TextStyle(
                            //               color: const Color(0xff3A98B9),
                            //               fontSize: 20)),
                            //     ],
                            //   ),
                            // ),
                            // RichText(
                            //   text: TextSpan(
                            //     children: <TextSpan>[
                            //       TextSpan(
                            //           text: '\t   \t"date" :',
                            //           style: TextStyle(
                            //               color: const Color(0xffADC4CE),
                            //               fontSize: 25)),
                            //       TextSpan(
                            //           text: '   unknown',
                            //           style: TextStyle(
                            //               color: const Color(0xff3A98B9),
                            //               fontSize: 25)),
                            //     ],
                            //   ),
                            // ),
                            // RichText(
                            //   text: TextSpan(
                            //     children: <TextSpan>[
                            //       TextSpan(
                            //           text: '\t   \t"time" :',
                            //           style: TextStyle(
                            //               color: const Color(0xffADC4CE),
                            //               fontSize: 25)),
                            //       TextSpan(
                            //           text: '   unknown',
                            //           style: TextStyle(
                            //               color: const Color(0xff3A98B9),
                            //               fontSize: 25)),
                            //     ],
                            //   ),
                            // ),
                            // RichText(
                            //   text: TextSpan(
                            //     children: <TextSpan>[
                            //       TextSpan(
                            //           text: '\t   \t"device" :',
                            //           style: TextStyle(
                            //               color: const Color(0xffADC4CE),
                            //               fontSize: 25)),
                            //       TextSpan(
                            //           text: '   unknown',
                            //           style: TextStyle(
                            //               color: const Color(0xff3A98B9),
                            //               fontSize: 25)),
                            //     ],
                            //   ),
                            // ),
                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "\n}",
                                      style: TextStyle(
                                          color: const Color(0xffADC4CE),
                                          fontSize: 25)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Container(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      primary: const Color(0xff2D4263),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          backgroundColor: Colors.black,
                          // title: const Text("Alert Dialog Box", style: TextStyle(color: const Color(0xff75C2F6)),),
                          title: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(right: 30),
                            color: Colors.black,
                          ),
                          actions: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: 'Details',
                                        style: TextStyle(
                                            color: const Color(0xffADC4CE),
                                            fontSize: 30)),
                                  ]),
                                ),
                                SizedBox(height: 10),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "{\n\n",
                                          style: TextStyle(
                                              color: const Color(0xffADC4CE),
                                              fontSize: 25)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: '\t"image" :',
                                        style: TextStyle(
                                            color: const Color(0xffADC4CE),
                                            fontSize: 25)),
                                  ]),
                                ),
                                Container(
                                  margin: EdgeInsets.all(20),
                                  height:
                                      MediaQuery.of(context).size.width * 0.5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      image: DecorationImage(
                                          image: FileImage(File(
                                              uploadimage?.path ??
                                                  "assets/1.jpeg")),
                                          fit: BoxFit.contain)),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '\t"name" :',
                                          style: TextStyle(
                                              color: const Color(0xffADC4CE),
                                              fontSize: 25)),
                                      TextSpan(
                                          text: '   ' + _nameController.text,
                                          style: TextStyle(
                                              color: const Color(0xff75C2F6),
                                              fontSize: 25)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '\t"location" :',
                                          style: TextStyle(
                                              color: const Color(0xffADC4CE),
                                              fontSize: 25)),
                                      TextSpan(
                                          text: '   '+_locationController.text,
                                          style: TextStyle(
                                              color: const Color(0xff75C2F6),
                                              fontSize: 25)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '\t"date" :',
                                          style: TextStyle(
                                              color: const Color(0xffADC4CE),
                                              fontSize: 25)),
                                      TextSpan(
                                          text: '   ' +
                                              DateTime.now()
                                                  .toString()
                                                  .substring(0, 11),
                                          style: TextStyle(
                                              color: const Color(0xff75C2F6),
                                              fontSize: 25)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '\t"time" :',
                                          style: TextStyle(
                                              color: const Color(0xffADC4CE),
                                              fontSize: 25)),
                                      TextSpan(
                                          text: '   ' +
                                              DateTime.now()
                                                  .toString()
                                                  .substring(11, 19),
                                          style: TextStyle(
                                              color: const Color(0xff75C2F6),
                                              fontSize: 25)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '\t"device" :',
                                          style: TextStyle(
                                              color: const Color(0xffADC4CE),
                                              fontSize: 25)),
                                      TextSpan(
                                          text: '   unknown',
                                          style: TextStyle(
                                              color: const Color(0xff75C2F6),
                                              fontSize: 25)),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "\n}",
                                          style: TextStyle(
                                              color: const Color(0xffADC4CE),
                                              fontSize: 25)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    print({
                                      "label": _nameController.text,
                                      "image": uploadimage,
                                      "location": _locationController.text,
                                      "date": DateTime.now()
                                          .toString()
                                          .substring(0, 11),
                                      "time": DateTime.now()
                                          .toString()
                                          .substring(11, 19),
                                      "device": "unknown"
                                    });
                                    birdsList.add({
                                      "label": _nameController.text,
                                      "image": uploadimage,
                                      "location": _locationController.text,
                                      "date": DateTime.now()
                                          .toString()
                                          .substring(0, 11),
                                      "time": DateTime.now()
                                          .toString()
                                          .substring(11, 19),
                                      "device": "unknown"
                                    });
                                    print(birdsList);
                                    // Add the data to Firestore.
                                    _addBirdToFirestore();

                                    // Pop the current screen.
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xff75C2F6),),
                                    padding: const EdgeInsets.all(14),
                                    child: const Text("confirm",
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text("add to catalogue"),
                    //color: Colors.deepOrangeAccent,
                    //colorBrightness: Brightness.dark,
                  ),
                ),
                Container(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 10.0,
                      primary: const Color(0xff2D4263),
                    ),
                    onPressed: () {
                      chooseImage();
                    },
                    icon: Icon(Icons.add_a_photo_rounded),
                    label: Text("Choose new image"),
                  ),
                ),
              ]),
              Container(
                  height: 40,
                  child: Marquee(
                    text:
                        "     * for best results crop the image to fit the bird      ",
                    style: TextStyle(color: Colors.red, fontSize: 15),
                  )),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xff2D4263),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff2D4263),
            ),
            child: Row(
              children: [
                Spacer(),
                IconButton(
                  onPressed: () {},
                  hoverColor: Colors.black,
                  color: Colors.amber,
                  tooltip: "Home",
                  iconSize: 30,
                  icon: Icon(Icons.search_rounded),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    // Navigator.pushNamed(context, 'listing', arguments: ["birds"]);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => ListingPage(itemList: birdsList),
                    ),);
                  },
                  hoverColor: Colors.black,
                  color: Colors.white,
                  highlightColor: Colors.black12,
                  tooltip: "Locate",
                  icon: Icon(
                    Icons.photo_library_rounded,
                  ),
                  iconSize: 30,
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'public');
                    // MaterialPageRoute(builder: (context) => PublicPage()),
                    // );
                  },
                  hoverColor: Colors.black,
                  color: Colors.white,
                  highlightColor: Colors.black12,
                  tooltip: "Locate",
                  icon: Icon(
                    Icons.leaderboard_rounded,
                  ),
                  iconSize: 30,
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfilePage()),
                    );
                  },
                  hoverColor: Colors.black,
                  color: Colors.white,
                  highlightColor: Colors.black12,
                  tooltip: "Profile",
                  icon: Icon(
                    Icons.person_rounded,
                  ),
                  iconSize: 30,
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller) {
    return InkWell(
      onTap: () {
        _editField(label, controller);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Text(
              '\t   \t"$label" :',
              style: TextStyle(
                color: const Color(0xffADC4CE),
                fontSize: 25,
              ),
            ),
            SizedBox(width: 8),
            Text(
              controller.text,
              style: TextStyle(
                color: const Color(0xff3A98B9),
                fontSize: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editField(String label, TextEditingController controller) async {
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        // Update the value when the user clicks Save in the dialog
        controller.text = result;
      });
    }
  }
}
