import 'dart:async';
import 'package:flutter/material.dart';
import 'package:harmonicsv2/screens/login_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            // decoration: BoxDecoration(color: Colors.purple[400]),
            decoration: BoxDecoration(
                gradient: RadialGradient(
              colors: [Colors.yellowAccent, Colors.blue],
              radius: 1.0,
            )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 150,
                                height: 150,
                                child: Image.asset("assets/images/logo2.png")),
                            // Container(
                            //     width: 150,
                            //     height: 200,
                            //     child: Image.asset("assets/images/logo1.png")),
                          ]),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "HARMONIC\nCALCULATOR",
                              style: TextStyle(
                                  fontSize: 35.0,
                                  fontFamily: 'JAVATA',
                                  color: Colors.white),
                            ),
                            Text(
                              "Harmonics are distorted electrical waveforms \n that introduce inefficiencies into your \n electrical system",
                              style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: <Widget>[
                    const LinearProgressIndicator(),
                    // CircularProgressIndicator(),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Text(
                      "Online Calculator\n   For Everyone\n       By  PEA",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
