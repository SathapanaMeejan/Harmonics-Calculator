import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harmonicsv2/providers/savefile_pdf.dart';
import 'package:harmonicsv2/screens/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;

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

    print("step" + "   kVAR" + "    harmonics order");
    for (var i = 1; i < (v6 + 1); i++) {
      var spower1 = (scpower * 1000) / (v5 * i);
      var spower2 = pow(spower1, 1 / 2);
      var spower3 = spower2.toStringAsFixed(2);
      print(" $i      ${v5 * i}         $spower3");
    }
    result1 =
        "Full Load Current   [I(FL)]  :    ${NumberFormat("#,###.##").format(flcurrent)}  A \n\nShort Circuit Current  [I(sc)]  :   ${NumberFormat("#,###.##").format(sccurrent)}  A\n\nShort Circuit Power  [S(sc)]  :    ${NumberFormat("#,###.##").format(scpower)}  MVA";

    List data1 = [
      "     STEP     " + "         kVAR        " + "    Harmonics Order   "
    ];
    List data2 = [];

    for (var i = 1; i < (v6 + 1); i++) {
      var spower1 = (scpower * 1000) / (v5 * i);
      var spower2 = pow(spower1, 1 / 2);
      var spower3 = spower2.toStringAsFixed(2);
      // result2 = " $i              ${v5 * i}             $spower3";
      data1.add(
          "$i                     ${v5 * i}                       $spower3   ");
      //1,5,7,11,13,17,19,23,25,29,31,35,37,41,...
      if (0 < spower2 && spower2 < 2) {
        data2.add('1');
      } else if (4 < spower2 && spower2 < 6) {
        data2.add('5');
      } else if (6 < spower2 && spower2 < 8) {
        data2.add('7');
      } else if (10 < spower2 && spower2 < 12) {
        data2.add('11');
      } else if (12 < spower2 && spower2 < 14) {
        data2.add('13');
      } else if (16 < spower2 && spower2 < 18) {
        data2.add('17');
      } else if (18 < spower2 && spower2 < 20) {
        data2.add('19');
      } else if (22 < spower2 && spower2 < 24) {
        data2.add('23');
      } else if (24 < spower2 && spower2 < 26) {
        data2.add('25');
      } else if (28 < spower2 && spower2 < 30) {
        data2.add('29');
      } else if (30 < spower2 && spower2 < 32) {
        data2.add('31');
      } else if (34 < spower2 && spower2 < 36) {
        data2.add('35');
      } else if (36 < spower2 && spower2 < 38) {
        data2.add('37');
      } else if (40 < spower2 && spower2 < 42) {
        data2.add('41');
      }
      data2 = data2.toSet().toList();
      //1,5,7,11,13,17,19,23,25,29,31,35,37,41,...
      print(data2);
    }

    Future<Uint8List> readImageData(String name) async {
      final data = await rootBundle.load("assets/images/$name");
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    }

    Future<void> createPDF() async {
      PdfDocument document = PdfDocument();
      final page = document.pages.add();

      page.graphics.drawImage(PdfBitmap(await readImageData('PEAlogo.png')),
          Rect.fromLTRB(160, 10, 100, 10));

      page.graphics.drawString(
          '\n\n\n\n\n\n\n\nProjectName\n    Project Name :  $projectFromFormScreen\n    Date :  $dateFromFormScreen\n\nCalculation\n    Full Load Current   [I(FL)]     :    ${NumberFormat("#,###.##").format(flcurrent)}  A \n    Short Circuit Current  [I(sc)]  :    ${NumberFormat("#,###.##").format(sccurrent)}  A\n    Short Circuit Power  [S(sc)]   :    ${NumberFormat("#,###.##").format(scpower)}  MVA\n\nResonance order\n    Harmonic order of danger :  $data2',
          PdfStandardFont(PdfFontFamily.helvetica, 20));

      // PdfGrid grid = PdfGrid();
      // grid.headers.add(1);
      // grid.columns.add(count: 3);

      // PdfGridRow header = grid.headers[0];
      // header.cells[0].value = 'STEP';
      // header.cells[1].value = 'kVAR';
      // header.cells[2].value = 'Harmonics Order';

      // PdfGridRow row = grid.rows.add();
      // row.cells[0].value = '1';
      // row.cells[1].value = '50';
      // row.cells[2].value = '17.92';

      // grid.draw(
      //     page: document.pages.add(),
      //     bounds: const Rect.fromLTWH(0, 0, 300, 0));

      List<int> bytes = document.save();
      document.dispose();

      saveAndLaunchFile(bytes, 'Output.pdf');
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
            Icon(
              Icons.beenhere_outlined,
              size: 30,
              color: Colors.white,
            ),
            // IconButton(
            //   icon: Icon(Icons.beenhere_outlined),
            //   iconSize: 30,
            //   color: Colors.white,
            //   onPressed: () {},
            // ),
            SizedBox(
              width: 10,
            )
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
                            height: 20,
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
                            width: 300,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(35, 10, 50, 0),
                                child: Text(
                                  'Harmonic order of danger :  ' +
                                      data2.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                ),
                              )
                            ],
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
                  // Container(
                  //   padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(25),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.grey.shade700,
                  //             blurRadius: 10,
                  //             offset: Offset(0, 1),
                  //           ),
                  //         ]),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           mainAxisAlignment: MainAxisAlignment.start,
                  //           children: [
                  //             Container(
                  //               padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                  //               child: Text(
                  //                 'Harmonics Graph',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 17,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //         Container(
                  //           child: Text("Detail"),
                  //         ),
                  //         SizedBox(
                  //           height: 30,
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
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
                            onPressed: createPDF,
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
