import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Birds {
  final String name;
  final String location;

  Birds(this.name, this.location);
}

class PublicPage extends StatefulWidget {
  const PublicPage({Key? key}) : super(key: key);

  @override
  State<PublicPage> createState() => _PublicPageState();
}

class _PublicPageState extends State<PublicPage> {

  final List<Birds> Bird = [
    Birds('Bird1', 'Sholinganalur'),
    Birds('Bird2', 'Vadapalani'),
    Birds('Bird3', 'Ambattur')
  ];

  void showDetails(BuildContext context, Birds bir ){
    showDialog(context: context,
        builder: (BuildContext context){
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
                    'Name: ${bir.name} \n Location: ${bir.location}',
                    style: TextStyle(fontSize: 22, color: Color(0xffADC4CE)),
                  )
                ],
              )
            )
        );
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
              itemBuilder: (context, index){
              final bir = Bird[index];
              final cardColor = index % 2 == 0 ? Colors.blue[50] : Colors.blue[100];
              return Card(
                margin: EdgeInsets.all(9.0),
                elevation: 10.0,
                color: cardColor,
                child: ListTile(
                  title: Text(bir.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
                  subtitle: Text(bir.location),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite, // Your favorite icon here
                      color: Colors.red, // Change color according to your design
                    ),
                    onPressed: () {
                      Provider.of<FavoriteModel>(context, listen: false).addToFavorites(bir.name);
                      // Implement adding to favorites or handling the favorite action
                    },
                  ),

                    onTap: () {
                    showDetails(context, bir);
                  }
                ),

              );
              }),
          ),
        ],
      ),
    );
  }
}
