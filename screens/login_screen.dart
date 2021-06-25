import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harmonicsv2/models/register_informations.dart';
import 'package:harmonicsv2/screens/home_screen.dart';
import 'package:harmonicsv2/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showPassword = false;
  final formKey = GlobalKey<FormState>();
  RegisterInformations registerinfo = RegisterInformations(
      email: '', password: '');
      
  //Firebase
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
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
              body: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: <Color>[Colors.yellowAccent, Colors.blue],
                      radius: 1.0,
                    ),
                  ),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 150,
                                        height: 150,
                                        child: Image.asset(
                                            "assets/images/logo2.png")),
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
                                  ]),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Welcome Back To Application",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(60),
                                topRight: Radius.circular(60),
                                // bottomLeft: Radius.circular(60),
                                // bottomRight: Radius.circular(60)
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(30),
                              child: ListView(
                                children: <Widget>[
                                  // SizedBox(
                                  //   height: 20,
                                  // ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(3, 200, 225, 3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10),
                                          ),
                                        ]),
                                    child: Form(
                                      key: formKey,
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(
                                                20, 10, 10, 10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey))),
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              decoration: InputDecoration(
                                                  hintText: "Email address",
                                                  icon: Icon(Icons.email),
                                                  hintStyle: TextStyle(
                                                      color: Colors.grey),
                                                  border: InputBorder.none),
                                              onSaved: (String? value) {
                                                registerinfo.email =
                                                    value!.trim();
                                              },
                                              validator: (String? value) {
                                                if (!((value!.contains("@")) &&
                                                    (value.contains(".")))) {
                                                  return 'Please Type Email in Email Format.';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey))),
                                            child: TextFormField(
                                              obscureText: !this._showPassword,
                                              decoration: InputDecoration(
                                                hintText: "Password",
                                                prefixIcon:
                                                    const Icon(Icons.lock),
                                                suffixIcon: IconButton(
                                                  icon: Icon(
                                                    Icons.remove_red_eye,
                                                    color: this._showPassword
                                                        ? Colors.blue
                                                        : Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    setState(() =>
                                                        this._showPassword =
                                                            !this._showPassword);
                                                  },
                                                ),
                                                hintStyle:
                                                    TextStyle(color: Colors.grey),
                                                border: InputBorder.none,
                                              ),
                                              onSaved: (String? value) {
                                                registerinfo.password =
                                                    value!.trim();
                                              },
                                              validator: (String? value) {
                                                if (value!.isEmpty) {
                                                  return 'Please Fill Your Password in the Blank';
                                                } else {
                                                  return null;
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Text(
                                    "You are new?  Sign up now!",
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      color: Colors.blue,
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          formKey.currentState!.save();
                                          try {
                                            await FirebaseAuth.instance.signInWithEmailAndPassword(
                                                    email: registerinfo.email,
                                                    password:registerinfo.password)
                                                .then((value) {
                                              formKey.currentState!.reset();
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen()));
                                            });
                                          } on FirebaseAuthException catch (e) {
                                            Fluttertoast.showToast(
                                                msg: e.message.toString(),
                                                gravity: ToastGravity.CENTER);
                                          }
                                          // print(
                                          //     "name = ${registerinfo.firstname} ${registerinfo.lastname},phone= ${registerinfo.phoneNumber},email= ${registerinfo.email},password= ${registerinfo.password}")
                                        }
                                      },
                                      child: Text(
                                        "Sign in",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      color: Colors.green,
                                      onPressed: () => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterScreen())),
                                      },
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ])),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.cancel),
                backgroundColor: Colors.red,
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
