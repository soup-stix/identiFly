import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ListingPage extends StatefulWidget {
  final List<dynamic> itemList;
  const ListingPage({Key? key, required this.itemList}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {

  List<dynamic> Bird = [];

  // Create a reference to the Firestore collection where you want to store the data.
  final CollectionReference birdsCollection = FirebaseFirestore.instance.collection('myBirds');


  @override
  void initState() {
    // TODO: implement initState
    print(widget.itemList);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff191919),
      appBar: AppBar(
        title: Text('My Finds'),
        centerTitle: true,
        backgroundColor: const Color(0xff2D4263),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Bird.length > 0 ?
          Expanded(
            child: ListView.builder(
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
                }),
          ) : Expanded(child: Text("no data")),
        ],
      ),
    );
  }
}
