
import 'package:identifly/splashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:identifly/imageupload.dart';
import 'package:identifly/publicpage.dart';

import 'package:identifly/myListing.dart';


int ?initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        //home: Wrapper(),
        initialRoute: initScreen == 0 || initScreen == null ? 'splash' : 'imageupload',
        routes: {
          'imageupload':(context) => MyUpload(),
          'splash':(context) => MySplash(),
          'public':(context) => PublicPage(),
          'listing':(context) => ListingPage(itemList: [],),

        }
    ),
  );
}

