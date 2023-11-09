import 'package:identifly/splashScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:identifly/imageupload.dart';
import 'package:identifly/publicpage.dart';

import 'package:identifly/myListing.dart';

int? initScreen;

class FavoriteModel with ChangeNotifier {
  List<String> favorites = [];

  void addToFavorites(String item) {
    favorites.add(item);
    notifyListeners(); // Notify listeners when favorites change
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initScreen = await prefs.getInt("initScreen");
  await prefs.setInt("initScreen", 1);
  print('initScreen ${initScreen}');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<FavoriteModel>(
          create: (context) => FavoriteModel(), // Initialize the FavoriteModel
        ),
        // Add other providers if needed
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //home: Wrapper(),
          initialRoute:
              initScreen == 0 || initScreen == null ? 'splash' : 'imageupload',
          routes: {
            'imageupload': (context) => MyUpload(),
            'splash': (context) => MySplash(),
            'public': (context) => PublicPage(),
            // 'listing': (context) => ListingPage(),
          }),
    ),
  );
}
