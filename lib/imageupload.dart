import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devlog;

class MyUpload extends StatefulWidget{
  const MyUpload({Key?key}): super(key: key);

  @override
  _MyUploadState createState() => _MyUploadState();
}

class _MyUploadState extends State<MyUpload> {
  File? uploadimage;
  bool isImageLoaded = false;
  dynamic _bird;
  String _label = "";
  dynamic _confidence;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    loadMyModel();
  }

  loadMyModel() async {
    var result = await Tflite.loadModel(
      labels: "assets/labels.txt", model:"assets/model_unquant.tflite"
    );

    print("resultant after loading model: $result");
  }

  applyModelOnImage(File file) async {
    var res = await Tflite.runModelOnImage(
        path: file.path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5
    );
    setState(() {
      _bird = res;
      _label = _bird[0]["label"].substring(2);
      _confidence = _bird[0]["confidence"]*100.0;
    });
    print(_bird);
  }

  void clickImage() async {
    final XFile? pickedImage =
    await _picker.pickImage(source: ImageSource.camera);
    if (pickedImage != null) {
      setState(() {
        uploadimage = File(pickedImage.path);
      });}
  }

  void chooseImage() async {
    var pickedImage = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        uploadimage = File(pickedImage.path);
        isImageLoaded = true;
      });}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              Spacer(),
              Container(
                  height: 50,
                  width: 50,
                  alignment: Alignment.centerLeft,
                  child: Image.network("https://cdn-icons-png.flaticon.com/512/2219/2219694.png")//Image.asset("gov.png",)
              ),
              Text("Identi", style: TextStyle(color: Colors.blue, fontSize: 30),),
              Text("Fly", style: TextStyle(color: Colors.amber, fontSize: 30),),
              Spacer(),
            ],
          ),
          backgroundColor: Colors.cyan,
        ),
        body: Container(
          height:600,
          alignment: Alignment.center,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center, //content alignment to center
            children: <Widget>[
              Spacer(),
              Text("Upload Bird Image", style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 20,),
              isImageLoaded ? Container(
                height: 275,
                width: 275,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: FileImage(File(uploadimage?.path ?? "assets/1.jpeg")),
                    fit: BoxFit.contain
                    )
                  ),
              ) : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Colors.white12,
                ),
                onPressed: (){
                  chooseImage();
                },
                child: Container(
                  alignment: Alignment.center,
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/attach.png")
                      ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(

                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      primary: Colors.blue,
                    ),
                  onPressed: (){
                    applyModelOnImage(uploadimage!);
                  },
                  icon:Icon(Icons.search_rounded),
                  label: Text("Find Bird"),
                  //color: Colors.deepOrangeAccent,
                  //colorBrightness: Brightness.dark,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.width*0.15,),
              _bird != null ?
              Text("I am "+ _confidence.toString().substring(0,4) +"% sure, It's a ", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),) :
              Text("Upload an Image to see result", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),),
              _bird != null ? Text(_label , style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 30),) : Text(""),
              SizedBox(height: MediaQuery.of(context).size.width*0.05,),
              _bird != null ? Text("Nice find 😻", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20),) : Text(""),
              Spacer(),
              Text("* for best results crop the image to fit the bird", style: TextStyle(color: Colors.red, fontSize: 10),)
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber,
          onPressed: (){
            chooseImage();
          },
          child: Icon(Icons.add_a_photo_rounded),
        ),
      ),
    );
  }
}