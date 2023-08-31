
import 'package:identifly/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:identifly/imageupload.dart';

int ?initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 0);
  print('initScreen ${initScreen}');
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: Wrapper(),
        initialRoute: 'splash',//initScreen == 0 || initScreen == null ? 'splash' : 'imageupload',
        routes: {
          'imageupload':(context) => MyUpload(),
          'splash':(context) => MySplash(),

        }
    ),
  );
}

