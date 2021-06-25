import 'dart:math';
import 'package:universal_html/html.dart' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harmonicsv2/screens/darwer_screen.dart';
import 'package:harmonicsv2/screens/form_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          // title: Text("Home"),
          backgroundColor: Colors.blueAccent,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  auth.currentUser!.email.toString(),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Icon(
              Icons.beenhere_outlined,
              size: 30,
            ),
            // IconButton(
            //   icon: Icon(Icons.beenhere_outlined),
            //   iconSize: 30,
            //   onPressed: () {},
            // ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        drawer: DrawerScreen(),
        body: Stack(
          fit: StackFit.expand, 
          children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            // decoration: BoxDecoration(color: Colors.purple[400]),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [Colors.blue, Colors.pink.shade200],
            )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Container(
                //   child:

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     IconButton(
                //       icon: Icon(Icons.format_list_bulleted),
                //       iconSize: 30,
                //       onPressed: () {},
                //     ),
                //     Text(
                //       "USERNAME",
                //       style:
                //           TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                //     ),
                //     SizedBox(
                //       width: 10,
                //     ),
                //     Icon(
                //       Icons.beenhere_outlined,
                //       size: 30,
                //     )
                //   ],
                // ),

                //       Container(
                //     padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         IconButton(
                //           icon: Icon(Icons.format_list_bulleted),
                //           iconSize: 30,
                //           onPressed: () {
                //             DrawerScreen();
                //           },
                //         ),
                //         Row(
                //           children: [
                //             Container(
                //               child: Text(
                //                 "USERNAME",
                //                 style: TextStyle(
                //                   fontSize: 15,
                //                   fontWeight: FontWeight.bold,
                //                 ),
                //               ),
                //             ),
                //             IconButton(
                //               icon: Icon(Icons.beenhere_outlined),
                //               iconSize: 30,
                //               onPressed: () {},
                //             ),
                //           ],
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade700,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ]),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Find your project here",
                        icon: Icon(Icons.search),
                      ),
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 5, 20, 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade700,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ]),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Text(
                              "RECENT",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.expand_more),
                            iconSize: 30,
                            onPressed: () {},
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(Icons.add_to_photos),
                        iconSize: 25,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FormScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.63,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(29.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade700,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ]),
                  
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("Project Information")
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Container(
                              child: Text("No data"),
                            ),
                          );
                        }
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs.map((document) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.primaries[Random().nextInt(Colors.primaries.length)],
                                radius: 25,
                                child:
                                    FittedBox(child: Text('CODE')),
                              ),
                              title: Text(document['project']+'  ---  '+'('+document['province']+')'),
                              subtitle: Text(document['date']),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  
                ),
              ],
            ),
          ),
        ]));
  }
}


//ทำตาราง,ทำanimation,search,Image,เรียงเวลา