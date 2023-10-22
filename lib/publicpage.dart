import 'package:flutter/material.dart';

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
              return Card(
                margin: EdgeInsets.all(9.0),
                child: ListTile(
                  title: Text(bir.name),
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
