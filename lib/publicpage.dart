import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';


class PublicPage extends StatefulWidget {
  const PublicPage({Key? key}) : super(key: key);

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {
  List<dynamic> Bird = [];

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

      // Get the user's birds array.
      final List<dynamic> birdsArray = documentSnapshot['birds'];

      setState(() {
        Bird = documentSnapshot['birds'];
      });

    }
  }

  Future<void> _addBirdToFirestore(dynamic bird) async {
    // Create a new document in the collection.
    final DocumentReference myBirdsDocument = birdsCollection.doc("anandarul47@gmail.com");
    // Await the Future<DocumentSnapshot<Object?>> object.
    final DocumentSnapshot<Object?> documentSnapshot = await myBirdsDocument.get();
    // Check if the document exists.
    if (documentSnapshot.exists) {
      // Get the user's birds array.
      final List<dynamic> birdsArray = documentSnapshot['favs'];

      // Add the new bird to the array.
      birdsArray.add(bird);

      // Set the updated birds array on the document.
      myBirdsDocument.update({'favs': birdsArray});
    } else {
      // The document does not exist, so create it.
      myBirdsDocument.set({
        'username': 'anandarul47@gmail.com',
        'favs': [],
      });
    }
  }

  void showDetails(BuildContext context, dynamic bir) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.black,
              content:
              // filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5.0),
                  height: MediaQuery.of(context).size.height * 0.4,
                  color: Color(0x2A292940),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name: ${bir["label"]} \n Location: ${bir["location"]}',
                        style: TextStyle(
                            fontSize: 22, color: Color(0xffADC4CE)),
                      )
                    ],
                  )));
        });
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
                  final cardColor =
                  index % 2 == 0 ? Colors.blue[50] : Colors.blue[100];
                  return Card(
                    margin: EdgeInsets.all(9.0),
                    elevation: 10.0,
                    color: cardColor,
                    child: ListTile(
                        leading: Image.network(bir["image"]),
                        title: Text(bir['label'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Text(bir["location"]),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Provider.of<FavoriteModel>(context).isFavorite(bir.toString()) ? Colors.red : Colors.white,// Your favorite icon here// Change color according to your design
                          ),
                          onPressed: () {
                            Provider.of<FavoriteModel>(context, listen: false).isFavorite(bir.toString()) ? {
                              Provider.of<FavoriteModel>(context, listen: false)
                                  .removeFromFavorites(bir.toString()),
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

                                : {Provider.of<FavoriteModel>(
                                context, listen: false)
                                .addToFavorites(bir.toString()),
                              _addBirdToFirestore(bir),
                              if (!favoriteBirds.contains(bir.toString())) {
                                Provider.of<FavoriteModel>(context, listen: false)
                                    .addToFavorites(bir.toString())
                              },
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
