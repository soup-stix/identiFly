import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'imageupload.dart';

class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: CarouselSlider(
          items: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://img.freepik.com/free-photo/jungle-forest-view-tropical-trees-generative-ai_169016-29337.jpg?w=1380&t=st=1693503627~exp=1693504227~hmac=a4acaba587c6e208b168da22496ac229f6ed9583efc5e154dddcbb4817af7829"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                            height: 50,
                            width: 50,
                            alignment: Alignment.centerLeft,
                            child: Image.network("https://cdn-icons-png.flaticon.com/512/2219/2219694.png")
                        ),
                        Text("Identi", style: TextStyle(color: Colors.blue, fontSize: 50),),
                        Text("Fly", style: TextStyle(color: Colors.amber, fontSize: 50),),
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),

            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage("https://img.freepik.com/free-vector/silhouette-forest-landscape-background_1308-73525.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                margin: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Text("Click a pic and predict!!\n", style: TextStyle(color: Colors.amber, fontSize: 25),),
                    Text("Catalogue all you findings,\n", style: TextStyle(color: Colors.amber, fontSize: 25),),
                    Text("Share with your friends,\n", style: TextStyle(color: Colors.amber, fontSize: 25),),
                    Text("explore more", style: TextStyle(color: Colors.amber, fontSize: 25),),
                    Spacer(),
                    ElevatedButton(onPressed:() {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyUpload()),
                      );
                    }, child: Text("Start", style: TextStyle(color: Colors.amber, fontSize: 15),)),
                    Spacer(),
                  ],
                ),
              ),
            ),

          ],
          carouselController: _controller,
          //Slider Container properties
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height*0.9,
            enlargeCenterPage: false,
            viewportFraction: 1.0,
            autoPlay: false,
            aspectRatio: 21 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          ),
        ),
    );
  }
}