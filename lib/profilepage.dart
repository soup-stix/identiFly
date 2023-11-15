import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool _isSelected = true;
  bool _isSelected2 = false;
  bool _isSelected3 = false;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  List<dynamic> Bird = [];
  List<dynamic> Followers = [];
  List<dynamic> Following = [];

  // Create a reference to the Firestore collection where you want to store the data.
  final CollectionReference birdsCollection = FirebaseFirestore.instance.collection('myBirds');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readFromFirestore();
  }

  void _readFromFirestore() async {
    // Create a new document in the collection.
    final DocumentReference myBirdsDocument = birdsCollection.doc("anandarul47@gmail.com");
    // Await the Future<DocumentSnapshot<Object?>> object.
    final DocumentSnapshot<Object?> documentSnapshot = await myBirdsDocument.get();
    // Check if the document exists.
    if (documentSnapshot.exists) {

      // Get the user's birds array.
      final List<dynamic> birdsArray = documentSnapshot['favs'];

      setState(() {
        Bird = documentSnapshot['favs'];
      });

    }
  }


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
            height: MediaQuery.of(context).size.width*0.06,
          ),
          Container(
            width: MediaQuery.of(context).size.width*0.9,
            padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color(0xff2D4263),
            ),
            child: Column(
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
                Text(
                  'username',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'welcome@gmail.com',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Sony Alpha 7',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(10.0),
          //   child: Text(
          //     'My Favourites:',
          //     style: TextStyle(
          //       fontSize: 24,
          //       color: Colors.white,
          //     ),
          //   ),
          // ),
          // Expan/ded(
          //   child: ListView.builder(
          //     itemCoun/t: favoriteModel.favorites.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return Card(
          //         child: ListTile(
          //           tileColor: Color(0xff2D4263),
          //           textColor: Colors.white,
          //           title: Text(favorite/Model.favorites[index]),
          //         ),
          //       );
          //     },
          // ),
          // ),
          SizedBox(height: 20,),
          Container(
            width: MediaQuery.of(context).size.width*0.8,
            height: MediaQuery.of(context).size.width*0.12,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), color: Color(0xff2D4263)),
            child: Row(
              children: [
                SizedBox(width: MediaQuery.of(context).size.width*0.02,),
                ChoiceChip(label: Text("Favourites"),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Colors.blueGrey,
                    labelStyle: TextStyle(
                      color: _isSelected ? Colors.white : Colors.black,
                    ),
                    selected: _isSelected,
                    onSelected: (newboolValue){
                      setState(() {
                        _isSelected = newboolValue;
                        _isSelected2 = false;
                        _isSelected3 = false;
                      });
                    }
                ),
                Spacer(),
                ChoiceChip(label: Text("Followers"),
                    backgroundColor: Colors.grey.shade100,
                    labelStyle: TextStyle(
                      color: _isSelected2 ? Colors.white : Colors.black,
                    ),
                    selectedColor: Colors.blueGrey,
                    selected: _isSelected2,
                    onSelected: (newboolValue){
                      setState(() {
                        _isSelected2 = newboolValue;
                        _isSelected = false;
                        _isSelected3 = false;
                      });
                    }
                ),
                Spacer(),
                ChoiceChip(label: Text("Following"),
                    backgroundColor: Colors.grey.shade100,
                    selectedColor: Colors.blueGrey,
                    selected: _isSelected3,
                    labelStyle: TextStyle(
                      color: _isSelected3 ? Colors.white : Colors.black,
                    ),
                    onSelected: (newboolValue){
                      setState(() {
                        _isSelected3 = newboolValue;
                        _isSelected = false;
                        _isSelected2 = false;
                      });
                    }
                ),
                SizedBox(width: MediaQuery.of(context).size.width*0.02,),
              ],
            ),
          ),
          SizedBox(height: 10,),
          _isSelected ? Expanded(
            child: Bird.length > 0 ? ListView.builder(
                itemCount: Bird.length,
                itemBuilder: (context, index){
                  final bir = Bird[index];
                  print(bir);
                  final cardColor = index % 2 == 0 ? Colors.blue[50] : Colors.blue[100];
                  return Card(
                      margin: EdgeInsets.all(9.0),
                      elevation: 10.0,
                      color: cardColor,
                      child: ListTile(
                        leading: SizedBox(width: 50, height: 50, child: Image.network(bir["image"])),
                        title: Text(bir["label"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Text(bir["location"]),
                      )
                  );
                }) : Text("You don't have any favourites", style: TextStyle(color: Colors.white, fontSize: 20),),
          ) : Container(),
          _isSelected2 ? Expanded(
            child: Followers.length > 0 ? ListView.builder(
                itemCount: Followers.length,
                itemBuilder: (context, index){
                  final bir = Followers[index];
                  print(bir);
                  final cardColor = index % 2 == 0 ? Colors.blue[50] : Colors.blue[100];
                  return Card(
                      margin: EdgeInsets.all(9.0),
                      elevation: 10.0,
                      color: cardColor,
                      child: ListTile(
                        leading: SizedBox(width: 50, height: 50, child: Image.network(bir["image"])),
                        title: Text(bir["label"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Text(bir["location"]),
                      )
                  );
                }) : Text("You have no followers", style: TextStyle(color: Colors.white, fontSize: 20),),
          ) : Container(),
          _isSelected3 ? Expanded(
            child: Following.length > 0 ? ListView.builder(
                itemCount: Following.length,
                itemBuilder: (context, index){
                  final bir = Following[index];
                  print(bir);
                  final cardColor = index % 2 == 0 ? Colors.blue[50] : Colors.blue[100];
                  return Card(
                      margin: EdgeInsets.all(9.0),
                      elevation: 10.0,
                      color: cardColor,
                      child: ListTile(
                        leading: SizedBox(width: 50, height: 50, child: Image.network(bir["image"])),
                        title: Text(bir["label"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Text(bir["location"]),
                      )
                  );
                }) : Text("You don't follow anyone", style: TextStyle(color: Colors.white, fontSize: 20),),
          ) : Container(),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: 1, // Just one item for the ExpansionTile
          //     itemBuilder: (BuildContext context, int index) {
          //       return Card(
          //         color: Colors.black,
          //         child: ExpansionTile(
          //           tilePadding: EdgeInsets.all(10.0),
          //           backgroundColor: Color(0xff2D4263),
          //           title: Text(
          //             'Favorites',
          //             style: TextStyle(
          //               fontSize: 20,
          //               color: Colors.white,
          //             ),
          //           ),
          //           children: [
          //             // List your favorites here
          //             for (dynamic favorite in Bird)
          //               ListTile(
          //                 leading: SizedBox(width: 50, height: 50, child: Image.network(favorite["image"])),
          //                 title: Text(favorite["label"],
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       color: Colors.white,
          //                     )),
          //                 subtitle: Text(favorite["location"]),
          //               ),
          //           ],
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

//
//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';
// import 'main.dart';
//
// class ProfilePage extends StatefulWidget {
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   File? _pickedImage;
//
//   Future<void> _pickImage() async {
//     final pickedFile =
//     await ImagePicker().getImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _pickedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   final List<String> name = [
//     "Bird1",
//     "Bird2",
//     "Bird3",
//     "Bird4",
//     "Bird5",
//     "Bird6",
//     "Bird7",
//     "Bird8",
//     "Bird9",
//     "Bird10",
//     "Bird11",
//     "Bird12"
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final favoriteModel = Provider.of<FavoriteModel>(context);
//
//     return Scaffold(
//       backgroundColor: const Color(0xff191919),
//       appBar: AppBar(
//         title: Text('User Profile'),
//         centerTitle: true,
//         leading: null,
//         actions: <Widget>[
//           ElevatedButton.icon(
//               icon: Icon(Icons.logout),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xff2D4263),
//               ),
//               onPressed: () {},
//               label: Text('Logout')),
//         ],
//         backgroundColor: const Color(0xff2D4263),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Container( // These are supposed to be the info of the user that soup-stix rejected
//           //   color: Color(0xff2D4263),
//           //   width: double.infinity,
//           //   padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
//           //   child: Text(
//           //     'Name: Welcome',
//           //     style: TextStyle(
//           //       fontSize: 20,
//           //       color: Colors.white,
//           //     ),
//           //     textAlign: TextAlign.center,
//           //   ),
//           // ),
//           SizedBox(
//             height: MediaQuery.of(context).size.width*0.06,
//           ),
//           Container(
//             width: MediaQuery.of(context).size.width*0.9,
//             padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               color: Color(0xff2D4263),
//             ),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       GestureDetector(
//                         // onTap: _pickedImage,
//                         child: Container(
//                           width: 100, // Adjust the size as needed
//                           height: 100, // Adjust the size as needed
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.grey[
//                             300], // Background color of the circular container
//                           ),
//                           child: Center(
//                             child: _pickedImage != null
//                                 ? Container(
//                               child: Image.file(
//                                 _pickedImage!,
//                                 width: 100, // Adjust the size as needed
//                                 height: 100, // Adjust the size as needed
//                                 fit: BoxFit.cover,
//                               ),
//                             ) // Display the picked image overlaid on a circular container
//                                 : IconButton(
//                               icon: Icon(Icons.photo),
//                               onPressed: _pickImage,
//                               iconSize: 50, // Adjust the size as needed
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                     //
//                   ),
//                 ),
//                 Text(
//                   'username',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 Text(
//                   'welcome@gmail.com',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 Text(
//                   'Sony Alpha 7',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(
//                   height: 5,
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Text(
//               'My Favourites:',
//               style: TextStyle(
//                 fontSize: 24,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//           // Expan/ded(
//           //   child: ListView.builder(
//           //     itemCoun/t: favoriteModel.favorites.length,
//           //     itemBuilder: (BuildContext context, int index) {
//           //       return Card(
//           //         child: ListTile(
//           //           tileColor: Color(0xff2D4263),
//           //           textColor: Colors.white,
//           //           title: Text(favorite/Model.favorites[index]),
//           //         ),
//           //       );
//           //     },
//           // ),
//           // ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: 1, // Just one item for the ExpansionTile
//               itemBuilder: (BuildContext context, int index) {
//                 return Card(
//                   color: Color(0xff2D4263),
//                   child: ExpansionTile(
//                     tilePadding: EdgeInsets.all(10.0),
//                     backgroundColor: Color(0xff2D4263),
//                     title: Text(
//                       'Favorites',
//                       style: TextStyle(
//                         fontSize: 20,
//                         color: Colors.white,
//                       ),
//                     ),
//                     children: [
//                       // List your favorites here
//                       for (String favorite in favoriteModel.favorites)
//                         ListTile(
//                           tileColor: Color(0xff2D4263),
//                           textColor: Colors.white,
//                           title: Text(favorite),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
