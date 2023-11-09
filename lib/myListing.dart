import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Birds {
  final String name;
  final String location;

  Birds(this.name, this.location);
}

class ListingPage extends StatefulWidget {
  final List<dynamic> itemList;
  const ListingPage({Key? key, required this.itemList}) : super(key: key);

  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {

  final List<Birds> Bird = [
    Birds('Bird1', 'Sholinganalur'),
    Birds('Bird2', 'Vadapalani'),
    Birds('Bird3', 'Ambattur')
  ];


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
                itemBuilder: (context, index){
                  final bir = Bird[index];
                  final cardColor = index % 2 == 0 ? Colors.blue[50] : Colors.blue[100];
                  return Card(
                      margin: EdgeInsets.all(9.0),
                      elevation: 10.0,
                      color: cardColor,
                      child: ListTile(
                        // leading: ,//Image.file(),
                        title: Text(bir.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            )),
                        subtitle: Text(bir.location),
                      )
                  );
                }),
          ),
        ],
      ),
    );
  }
}
