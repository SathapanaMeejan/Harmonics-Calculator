
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harmonicsv2/screens/home_screen.dart';
import 'package:intl/intl.dart';

class ResultScreen extends StatelessWidget {
  final String dateFromFormScreen;
  final String projectFromFormScreen;
  var ratedpowerFromFormScreen;
  var ratedvoltageFromFormScreen;
  var lowvoltageFromFormScreen;
  var percentzFromFormScreen;
  var qcFromFormScreen;
  var stepFromFormScreen;
  ResultScreen({
    Key? key,
    required this.dateFromFormScreen,
    required this.projectFromFormScreen,
    required this.ratedpowerFromFormScreen,
    required this.ratedvoltageFromFormScreen,
    required this.lowvoltageFromFormScreen,
    required this.percentzFromFormScreen,
    required this.qcFromFormScreen,
    required this.stepFromFormScreen,
  }) : super(key: key);

  FirebaseAuth firebasesAuth = FirebaseAuth.instance;
  String result1 = '';
  String result2 = '';

  @override
  Widget build(BuildContext context) {
    var v1 = int.parse('$ratedvoltageFromFormScreen');
    var v2 = int.parse('$lowvoltageFromFormScreen');
    var v3 = int.parse('$ratedpowerFromFormScreen');
    var v4 = double.parse('$percentzFromFormScreen');
    var v5 = int.parse('$qcFromFormScreen');
    var v6 = int.parse('$stepFromFormScreen');

    var flcurrent = (v3 * 1000) / (1.732 * v2);
    print("I(FL): ${NumberFormat("#,###.##").format(flcurrent)} A ");
    var sccurrent = (flcurrent * 100) / v4;
    print("I(sc): ${NumberFormat("#,###.##").format(sccurrent)} A ");
    var scpower = (1.732 * sccurrent * v2) / 1000000;
    print("S(sc): ${NumberFormat("#,###.##").format(scpower)} MVA ");

    print("step" + "   kVAR" + "    h");
    for (var i = 1; i < (v6 + 1); i++) {
      var spower1 = (scpower * 1000) / (v5 * i);
      var spower2 = pow(spower1, 1 / 2);
      var spower3 = spower2.toStringAsFixed(3);
      print(" $i      ${v5 * i}   $spower3");
      result1 =
          "Full Load Current   [I(FL)]  :    ${NumberFormat("#,###.##").format(flcurrent)}  A \n\nShort Circuit Current  [I(sc)]  :   ${NumberFormat("#,###.##").format(sccurrent)}  A\n\nShort Circuit Power  [S(sc)]  :    ${NumberFormat("#,###.##").format(scpower)}  MVA";
    }
    List data1 = ["step         " + " kVAR            " + "    h       "];
    // List data2 = [];
    // List data3 = [];
    for (var i = 1; i < (v6 + 1); i++) {
      var spower1 = (scpower * 1000) / (v5 * i);
      var spower2 = pow(spower1, 1 / 2);
      var spower3 = spower2.toStringAsFixed(3);
      // result2 = " $i              ${v5 * i}             $spower3";

      data1.add(" $i              ${v5 * i}             $spower3");
      // data2.add('${v5 * i}');
      // data3.add('$spower3');
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  firebasesAuth.currentUser!.email.toString(),
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.beenhere_outlined),
              iconSize: 30,
              color: Colors.white,
              onPressed: () {},
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.blue, Colors.pink.shade200]),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade700,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                                child: Text(
                                  'Project Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(50, 0, 0, 5),
                                  child: Text(
                                    'Project Name',
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    height: 30,
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Text(
                                      '$projectFromFormScreen',
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(50, 0, 0, 5),
                                  child: Text('Date'),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                    height: 30,
                                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                    child: Text(
                                      '$dateFromFormScreen',
                                      style: TextStyle(color: Colors.black),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade700,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                                child: Text(
                                  'Calculation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    result1,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade700,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ]),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                                child: Text(
                                  'Resonance order',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: 230,
                            child: Table(
                                border: TableBorder.all(
                                    width: 1.0,
                                    color: Colors.black,
                                    style: BorderStyle.solid),
                                children: [
                                  for (var showdata1 in data1)
                                    TableRow(children: [
                                      TableCell(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            new Text(
                                              showdata1.toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      )
                                    ])
                                ]),
                          ),
                          // DataTable(
                          //   columns: [
                          //     DataColumn(label: Text("STEP")),
                          //     DataColumn(label: Text("kVAR")),
                          //     DataColumn(label: Text("Harmonics Order")),
                          //   ],
                          //   rows: [
                          //     DataRow(cells: [
                          //       DataCell(Text("1")),
                          //       DataCell(Text("50")),
                          //       DataCell(Text("17.92")),
                          //     ]),
                          //     DataRow(cells: [
                          //       DataCell(Text("2")),
                          //       DataCell(Text("100")),
                          //       DataCell(Text("12.67")),
                          //     ]),
                          //   ],
                          // ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(130, 10, 130, 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(60),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade700,
                              blurRadius: 10,
                              offset: Offset(0, 1),
                            ),
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.home),
                            iconSize: 25,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.download),
                            iconSize: 25,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                  )
                ],
              ),
            )
          ],
        ));
  }
}