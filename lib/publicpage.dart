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
