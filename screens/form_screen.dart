import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harmonicsv2/models/informations.dart';
import 'package:harmonicsv2/screens/result_screen.dart';
import 'package:harmonicsv2/screens/result_screen2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:universal_html/html.dart' as html;

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final formKey = GlobalKey<FormState>();
  Informations info = Informations(
      customer: '',
      date: DateTime.now(),
      lowvoltage: '',
      percentz: '',
      phone: '',
      project: '',
      province: '',
      qc: '',
      ratedpower: '',
      step: '',
      ratedvoltage: '',
      mdb: '');

  //เตรียม Firebase
  final Future<FirebaseApp> firebase2 = Firebase.initializeApp();

  CollectionReference infoCollection =
      FirebaseFirestore.instance.collection("Project Information");

  var projectnameController = TextEditingController();
  var customerController = TextEditingController();
  var phoneController = TextEditingController();
  var provinceController = TextEditingController();
  var dateController = TextEditingController();
  var ratedpowerController = TextEditingController();
  var ratedvoltageController = TextEditingController();
  var lowvoltageController = TextEditingController();
  var percentzController = TextEditingController();
  var qcController = TextEditingController();
  var stepController = TextEditingController();
  var mdbController = TextEditingController();

  String formattedDate =
      // DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
      DateFormat('dd/MM/yyyy').format(DateTime.now());

  //การถ่ายภาพ
  File? _imageFile1, _imageFile2, _imageFile3;
  final _imagePicker = ImagePicker();
  String? urlPicture1, urlPicture2, urlPicture3;

  Future<void> getImage1(ImageSource imageSource) async {
    try {
      var image1 = await _imagePicker.getImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        _imageFile1 = File(image1!.path);
      });
    } catch (e) {}
  }

  Future<void> getImage2(ImageSource imageSource) async {
    try {
      var image2 = await _imagePicker.getImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        _imageFile2 = File(image2!.path);
      });
    } catch (e) {}
  }

  Future<void> getImage3(ImageSource imageSource) async {
    try {
      var image3 = await _imagePicker.getImage(
        source: imageSource,
        maxWidth: 800.0,
        maxHeight: 800.0,
      );
      setState(() {
        _imageFile3 = File(image3!.path);
      });
    } catch (e) {}
  }

  // Future<Null> getGallery() async {
  //   final image = await _imagePicker.getImage(source: ImageSource.gallery);

  //   setState(() {
  //     _imageFile = File(image!.path);
  //   });
  // }
  final auth = FirebaseAuth.instance;
  

  Future<void> uploadPictureToStorage() async {
    // Random random = Random();
    // int i = random.nextInt(1000000);

    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    var snapshot1 = await firebaseStorage
        .ref()
        .child('Project Harmonics/image_' + DateTime.now().toString() + '.jpg');
    var snapshot2 = await firebaseStorage
        .ref()
        .child('Project Harmonics/image_' + DateTime.now().toString() + '.jpg');
    var snapshot3 = await firebaseStorage
        .ref()
        .child('Project Harmonics/image_' + DateTime.now().toString() + '.jpg');
    UploadTask storageUploadTask1 = snapshot1.putFile(_imageFile1!);
    UploadTask storageUploadTask2 = snapshot2.putFile(_imageFile2!);
    UploadTask storageUploadTask3 = snapshot3.putFile(_imageFile3!);

    String urlPicture1 = await (await storageUploadTask1).ref.getDownloadURL();
    String urlPicture2 = await (await storageUploadTask2).ref.getDownloadURL();
    String urlPicture3 = await (await storageUploadTask3).ref.getDownloadURL();
    print('urlPicture1 = $urlPicture1');
    // print('urlPicture2 = $urlPicture2');
    // print('urlPicture3 = $urlPicture3');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase2,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(
                title: Text("Error"),
              ),
              body: Center(
                child: Text("${snapshot.error}"),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.blue,
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        auth.currentUser!.email.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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
                  //   color: Colors.white,
                  //   onPressed: () {},
                  // ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              body: ListView(
                // fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    // color: Colors.white,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.blue, Colors.pink.shade200]
                          // radius: 1.0
                          ),
                    ),
                    child: Form(
                      key: formKey,
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
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 0, 10),
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
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text(
                                            'Project Name',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: projectnameController,
                                            decoration: InputDecoration(
                                              labelText: 'ชื่อโปรเจค',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.project = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Your Project in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text(
                                            'MDB Number',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: mdbController,
                                            decoration: InputDecoration(
                                              labelText: 'เลขตู้ MDB',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.mdb = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Your MDB Number in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text('Customer Name'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: customerController,
                                            decoration: InputDecoration(
                                              labelText: 'ชื่อลูกค้า',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.customer = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Customer Name in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text('Province'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.text,
                                            controller: provinceController,
                                            decoration: InputDecoration(
                                              labelText: 'จังหวัด',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.province = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Province in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text('Phone'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            keyboardType: TextInputType.phone,
                                            controller: phoneController,
                                            decoration: InputDecoration(
                                              labelText: 'เบอร์โทร',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.phone = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Phone in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text('Date'),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.access_time_outlined),
                                        iconSize: 25,
                                        color: Colors.blue,
                                        onPressed: () => {
                                          dateController.text = formattedDate
                                        },
                                      ),

                                      Container(
                                        width: 188,
                                        height: 43,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: TextFormField(
                                          controller: dateController,
                                          keyboardType: TextInputType.datetime,
                                          decoration: InputDecoration(
                                            labelText: 'วันที่/เดือน/ปี',
                                            labelStyle: TextStyle(
                                                fontSize: 15,
                                                color: Colors.blue),
                                            border: OutlineInputBorder(),
                                          ),
                                          onSaved: (String? value) {
                                            info.date = DateTime.now();
                                          },
                                          validator: (String? value) {
                                            if (value!.isEmpty) {
                                              return 'Please Fill Date in the Blank';
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),
                                      ),

                                      // ignore: deprecated_member_use
                                    ],
                                  ),
                                  SizedBox(
                                    height: 43,
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
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 0, 10),
                                        child: Text(
                                          'Transformer',
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
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text(
                                            'Rated Power(kVA)',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            controller: ratedpowerController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Rated Power',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.ratedpower = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Rated Power in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text('%Impedance'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            controller: percentzController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: '%Impedance',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.percentz = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Your %Impedance in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 0, 0, 5),
                                          child: Text('Low Voltage side(VLL)'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            controller: lowvoltageController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Rated Voltage(VLL)',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.lowvoltage = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Low Voltage in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 43,
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
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 0, 10),
                                        child: Text(
                                          'Capacitor Bank',
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
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text(
                                            'Capacitor Step',
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            controller: stepController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Capacitor Step',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.qc = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Capacitor Step in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(45, 0, 0, 5),
                                          child: Text('kVAR/Step'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            controller: qcController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'kVAR/Step',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.step = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Step in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(30, 0, 0, 5),
                                          child: Text('Rated Voltage(VLL)'),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 43,
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 10, 0),
                                          child: TextFormField(
                                            controller: ratedvoltageController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Rated Voltage',
                                              labelStyle: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.blue),
                                              border: OutlineInputBorder(),
                                            ),
                                            onSaved: (String? value) {
                                              info.ratedvoltage = value!.trim();
                                            },
                                            validator: (String? value) {
                                              if (value!.isEmpty) {
                                                return 'Please Fill Rated Voltage in the Blank';
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 43,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Container(
                              height: 280,
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
                                        padding:
                                            EdgeInsets.fromLTRB(20, 20, 0, 10),
                                        child: Text(
                                          'Image',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                                      //   child: Row(
                                      //     children: [
                                      //       IconButton(
                                      //         onPressed: getImage,
                                      //         icon: Icon(Icons.photo_camera),
                                      //         tooltip: 'Shoot picture',
                                      //       ),
                                      //       IconButton(
                                      //         onPressed: getGallery,
                                      //         icon: Icon(Icons.photo),
                                      //         tooltip: 'Pick from gallery',
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  // Row(
                                  //   children: <Widget>[
                                  //     Container(
                                  //       child: _imageFile == null? Text('No Image Selected'):Image.file(_imageFile))
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.grey.shade300,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              padding: EdgeInsets.all(5),
                                              child: _imageFile1 == null
                                                  ? null
                                                  : Image.file(_imageFile1!),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      getImage1(
                                                          ImageSource.camera);
                                                    },
                                                    icon: Icon(
                                                        Icons.photo_camera)),
                                                IconButton(
                                                  onPressed: () {
                                                    getImage1(
                                                        ImageSource.gallery);
                                                  },
                                                  icon: Icon(Icons.photo),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.grey.shade300,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              padding: EdgeInsets.all(5),
                                              child: _imageFile2 == null
                                                  ? null
                                                  : Image.file(_imageFile2!),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      getImage2(
                                                          ImageSource.camera);
                                                    },
                                                    icon: Icon(
                                                        Icons.photo_camera)),
                                                IconButton(
                                                  onPressed: () {
                                                    getImage2(
                                                        ImageSource.gallery);
                                                  },
                                                  icon: Icon(Icons.photo),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              color: Colors.grey.shade300,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.2,
                                              padding: EdgeInsets.all(5),
                                              child: _imageFile3 == null
                                                  ? null
                                                  : Image.file(_imageFile3!),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      getImage3(
                                                          ImageSource.camera);
                                                    },
                                                    icon: Icon(
                                                        Icons.photo_camera)),
                                                IconButton(
                                                  onPressed: () {
                                                    getImage3(
                                                        ImageSource.gallery);
                                                  },
                                                  icon: Icon(Icons.photo),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 25, 0, 45),
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              color: Colors.blue,
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  await infoCollection.add({
                                    "project": info.project,
                                    "mdb": info.mdb,
                                    "customer": info.customer,
                                    "province": info.province,
                                    "phone": info.phone,
                                    "date": info.date.toIso8601String(),
                                    "ratedpower": info.ratedpower,
                                    "%impedance": info.percentz,
                                    "lowvoltage": info.lowvoltage,
                                    "capacitor step": info.qc,
                                    "step": info.step,
                                    "ratedvoltage": info.ratedvoltage
                                  });
                                } else if (_imageFile1 == null) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Center(
                                              child:
                                                  Text("Non Choose Picture")),
                                          content: Text(
                                              "Please Click Camera or Gallery"),
                                          actions: [
                                            // ignore: deprecated_member_use
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child:
                                                    Center(child: Text("OK")))
                                          ],
                                        );
                                      });
                                } else if (formKey.currentState!.validate() &&
                                    _imageFile1 != null &&
                                    _imageFile2 != null &&
                                    _imageFile3 != null) {
                                  formKey.currentState!.reset();
                                }
                                
                                if (_imageFile1 != null &&
                                    _imageFile2 != null &&
                                    _imageFile3 != null) {
                                  uploadPictureToStorage();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              ResultScreen(
                                                projectFromFormScreen:
                                                    projectnameController.text,
                                                dateFromFormScreen:
                                                    dateController.text,
                                                ratedpowerFromFormScreen:
                                                    ratedpowerController.text,
                                                ratedvoltageFromFormScreen:
                                                    ratedvoltageController.text,
                                                lowvoltageFromFormScreen:
                                                    lowvoltageController.text,
                                                percentzFromFormScreen:
                                                    percentzController.text,
                                                qcFromFormScreen:
                                                    qcController.text,
                                                stepFromFormScreen:
                                                    stepController.text,
                                                mdbFromFormScreen: 
                                                    mdbController.text,
                                              ),
                                              
                                      
                                      ));
                                }
                              },
                              child: Text(
                                "Save and Calculate",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
