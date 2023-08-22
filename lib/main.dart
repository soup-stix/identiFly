
import 'package:flutter/material.dart';
import 'package:identifly/imageupload.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: Wrapper(),
        initialRoute: 'imageupload',
        routes: {
          'imageupload':(context) => MyUpload(),

        }
    ),
  );
}

