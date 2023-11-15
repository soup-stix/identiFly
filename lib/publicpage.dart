import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'main.dart';


class PublicPage extends StatefulWidget {
  const PublicPage({Key? key}) : super(key: key);

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
  List<dynamic> Bird = [];
  List<dynamic> Favs = [];

  Set<String> favoriteBirds = Set<String>();

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
      setState(() {
        Bird = documentSnapshot['birds'];
        Favs = documentSnapshot['favs'];
      });
      print(Bird);
      print(Favs);

    }
  }


  // Future<void> _addBirdToFirestore(dynamic bird) async {
  //   // Create a new document in the collection.
  //   final DocumentReference myBirdsDocument = birdsCollection.doc("anandarul47@gmail.com");
  //   // Await the Future<DocumentSnapshot<Object?>> object.
  //   final DocumentSnapshot<Object?> documentSnapshot = await myBirdsDocument.get();
  //   // Check if the document exists.
  //   if (documentSnapshot.exists) {
  //     // Get the user's birds array.
  //     final List<dynamic> birdsArray = documentSnapshot['favs'];
  //
  //     // Add the new bird to the array.
  //     birdsArray.add(bird);
  //
  //     // Set the updated birds array on the document.
  //     myBirdsDocument.update({'favs': birdsArray});
  //   } else {
  //     // The document does not exist, so create it.
  //     myBirdsDocument.set({
  //       'username': 'anandarul47@gmail.com',
  //       'favs': [],
  //     });
  //   }
  // }

  Future<void> _addBirdToFavs(dynamic bird) async {
    // Create a new document in the collection.
    final DocumentReference myBirdsDocument = await birdsCollection.doc("anandarul47@gmail.com");

    // Await the Future<DocumentSnapshot<Object?>> object.
    DocumentSnapshot<Object?> documentSnapshot = await myBirdsDocument.get();

    // Check if the document exists.
    if (documentSnapshot.exists) {
      // Get the user's birds array.
      final List<dynamic> birdsArray = documentSnapshot['favs'];

      // Check if a bird with the same image already exists.
      bool birdExists = birdsArray.any((existingBird) => existingBird['image'] == bird['image']);

      if (!birdExists) {
        // Add the new bird to the array.
        birdsArray.add(bird);

        // Set the updated birds array on the document.
        await myBirdsDocument.update({'favs': birdsArray});
        // Fetch the updated data after the update.
        documentSnapshot = await myBirdsDocument.get();

        // Update the local state with the updated data.
        setState(() {
          Bird = List.from(documentSnapshot['Bird']);
          Favs = List.from(documentSnapshot['favs']);
        });
      } else {
        // Handle the case where a bird with the same image already exists.
        print('Bird with the same image already exists.');
      }
    } else {
      // The document does not exist, so create it.
      myBirdsDocument.set({
        'username': 'anandarul47@gmail.com',
        'favs': [bird], // Initialize the array with the new bird.
      });
    }
  }

  Future<void> _removeBirdFromFavs(dynamic bird) async {
    try {
      // Create a new document reference in the 'birds' collection.
      final DocumentReference myBirdsDocument = await birdsCollection.doc("anandarul47@gmail.com");

      // Await the Future<DocumentSnapshot<Object?>> object.
      DocumentSnapshot<Object?> documentSnapshot = await myBirdsDocument.get();

      // Check if the document exists.
      if (documentSnapshot.exists) {
        // Get the user's birds array.
        final List<dynamic> birdsArray = await documentSnapshot['favs'];

        // Find the index of the bird with the specified image.
        int birdIndex = birdsArray.indexWhere((existingBird) => existingBird['image'] == bird['image']);

        if (birdIndex != -1) {
          // Remove the bird from the array.
          birdsArray.removeAt(birdIndex);

          // Set the updated birds array on the document.
          await myBirdsDocument.update({'favs': birdsArray});
          // Fetch the updated data after the update.
          documentSnapshot = await myBirdsDocument.get();

          // Update the local state with the updated data.
          setState(() {
            Bird = List.from(documentSnapshot['Bird']);
            Favs = List.from(documentSnapshot['favs']);
          });
        } else {
          // Handle the case where the bird to remove is not found in the array.
          print('Bird not found in the favs array.');
        }
      } else {
        // Handle the case where the document does not exist.
        print('Document does not exist.');
      }
    } catch (e) {
      // Handle any exceptions that may occur.
      print('Error removing bird from favs: $e');
    }
  }

  void showDetails(BuildContext context, dynamic bir) {
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
                      text: 'Posted by: Anand',
                      style: TextStyle(
                          color: const Color(0xffADC4CE),
                          fontSize: 20)),
                ]),
              ),
              RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: 'Details',
                      style: TextStyle(
                          color: const Color(0xffADC4CE),
                          fontSize: 20)),
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
                        image: NetworkImage(bir["image"]),
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
                        text: '   ' + bir["label"],
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
                  // Pop the current screen.
                  Navigator.of(ctx).pop();
                },
                child: Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xff75C2F6),),
                      child: const Text("close",
                          style: TextStyle(color: Colors.black)),
                    ),
                    SizedBox(width: 10,),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color(0xff75C2F6),),
                      padding: const EdgeInsets.all(14),
                      child: const Text("follow",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191919),
      appBar: AppBar(
        title: Text('Connect All'),
        centerTitle: true,
        backgroundColor: const Color(0xff2D4263),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: Bird.length,
                itemBuilder: (context, index) {
                  final bir = Bird[index];
                  // bool isFavorite = Favs.contains(bir);
                  bool isFavorite = Favs.any((fav) => fav["image"] == bir["image"]);
                  final cardColor =
                  index % 2 == 0 ? Colors.blue[50] : Colors.blue[100];
                  return Card(
                    margin: EdgeInsets.all(9.0),
                    elevation: 10.0,
                    color: cardColor,
                    child: ListTile(
                        leading: SizedBox(width: 50, height: 50, child: Image.network(bir["image"])),
                        title: Text(bir['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Text(bir["location"]),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: isFavorite ? Colors.red : Colors.white,// Your favorite icon here// Change color according to your design
                          ),
                          onPressed: () {
                            Favs.any((fav) => fav["image"] == bir["image"]) ? {
                              // Provider.of<FavoriteModel>(context, listen: false)
                              //     .removeFromFavorites(bir.toString()),
                              setState(() {
                                _removeBirdFromFavs(bir);
                                _readFromFirestore();
                              }),
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      backgroundColor: Colors.black38,
                                      title: Center(
                                        child: const Text(
                                          'Removed from Favorites',
                                          style:
                                          TextStyle(color: Color(0xffADC4CE)),
                                        ),
                                      ),
                                    );
                                  })
                            }

                                : {
                              // Provider.of<FavoriteModel>(
                              //   context, listen: false)
                              //   .addToFavorites(bir.toString()),
                              setState(() {
                                _addBirdToFavs(bir);
                                _readFromFirestore();
                              }),
                              // if (!favoriteBirds.contains(bir.toString())) {
                              //   Provider.of<FavoriteModel>(context, listen: false)
                              //       .addToFavorites(bir.toString())
                              // },
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const AlertDialog(
                                      backgroundColor: Colors.black38,
                                      title: Center(
                                        child: const Text(
                                          'Added to Favorites',
                                          style:
                                          TextStyle(color: Color(0xffADC4CE)),
                                        ),
                                      ),
                                    );
                                  })
                            };
                            setState(() {

                            });
                            // Provider.of<FavoriteModel>(context, listen: false)
                            //     .addToFavorites(bir.name);
                            // Implement adding to favorites or handling the favorite action
                          },
                        ),
                        onTap: () {
                          showDetails(context, bir);
                        }),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
