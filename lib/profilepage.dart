import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
            label: Text('Logout')
          ),
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
                Container(
                    width: 80, // Set the width and height for the circle
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green, // Change the color of the circle
                    ),
                    child: Center(
                        child: IconButton(
                      icon: const Icon(Icons.person_pin_rounded, size: 27),
                      onPressed: () {},
                    )))
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
          SizedBox(height: 5,),
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
              itemCount: name.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    tileColor: Color(0xff2D4263),
                    textColor: Colors.white,
                    title: Text(name[index]),
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
