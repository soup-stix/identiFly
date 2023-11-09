import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _pickedImage;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  final List<String> name = [
    "Bird1",
    "Bird2",
    "Bird3",
    "Bird4",
    "Bird5",
    "Bird6",
    "Bird7",
    "Bird8",
    "Bird9",
    "Bird10",
    "Bird11",
    "Bird12"
  ];
  @override
  Widget build(BuildContext context) {
    final favoriteModel = Provider.of<FavoriteModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xff191919),
      appBar: AppBar(
        title: Text('User Profile'),
        centerTitle: true,
        leading: null,
        actions: <Widget>[
          ElevatedButton.icon(
              icon: Icon(Icons.logout),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff2D4263),
              ),
              onPressed: () {},
              label: Text('Logout')),
        ],
        backgroundColor: const Color(0xff2D4263),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  // onTap: _pickedImage,
                  child: Container(
                    width: 100, // Adjust the size as needed
                    height: 100, // Adjust the size as needed
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[
                          300], // Background color of the circular container
                    ),
                    child: Center(
                      child: _pickedImage != null
                          ? Container(
                              child: Image.file(
                                _pickedImage!,
                                width: 100, // Adjust the size as needed
                                height: 100, // Adjust the size as needed
                                fit: BoxFit.cover,
                              ),
                            ) // Display the picked image overlaid on a circular container
                          : IconButton(
                              icon: Icon(Icons.photo),
                              onPressed: _pickImage,
                              iconSize: 50, // Adjust the size as needed
                            ),
                    ),
                  ),
                ),
              ],
              //
            ),
          ),
          // Container( // These are supposed to be the info of the user that soup-stix rejected
          //   color: Color(0xff2D4263),
          //   width: double.infinity,
          //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
          //   child: Text(
          //     'Name: Welcome',
          //     style: TextStyle(
          //       fontSize: 20,
          //       color: Colors.white,
          //     ),
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          SizedBox(
            height: 5,
          ),
          Container(
            color: Color(0xff2D4263),
            width: double.infinity,
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            child: Text(
              'welcome@gmail.com',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Favorite Birds:',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favoriteModel.favorites.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    tileColor: Color(0xff2D4263),
                    textColor: Colors.white,
                    title: Text(favoriteModel.favorites[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
