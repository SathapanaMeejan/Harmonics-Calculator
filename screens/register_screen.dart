import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:harmonicsv2/models/register_informations.dart';
import 'package:harmonicsv2/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();

  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  RegisterInformations registerinfo = RegisterInformations(
      email: '', password: '');

  //Firebase
  final Future<FirebaseApp> firebase1 = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase1,
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
                  backgroundColor: Colors.teal.shade300,
                  title: Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
                body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Colors.yellowAccent, Colors.blue],
                      radius: 1.0,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            // color: Color.fromRGBO(3, 200, 225, 3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            children: <Widget>[
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  icon: Icon(
                                    Icons.email,
                                    color: Colors.grey,
                                    size: 35,
                                  ),
                                  labelText: "Email address",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                                onSaved: (String? value) {
                                  registerinfo.email = value!.trim();
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
                              SizedBox(
                                height: 10,
                              ),
                              PasswordField(
                                fieldKey: _passwordFieldKey,
                                helperText: "No more than 8 characters.",
                                labelText: "Password *",
                                onFieldSubmitted: (String? value) {
                                  setState(() {
                                    this.registerinfo.password = value!;
                                  });
                                },
                                hintText: '',
                                onSaved: (String? value) {
                                  registerinfo.password = value!.trim();
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please Fill Your Password in the Blank';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                enabled: this.registerinfo.password != null,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock,
                                      color: Colors.grey, size: 35),
                                  border: InputBorder.none,
                                  filled: true,
                                  labelText: "Re-type password",
                                ),
                                validator: (String? value) {
                                  if (value == this.registerinfo.password) {
                                    return 'Password do not Match';
                                  } else {
                                    return null;
                                  }
                                },
                                maxLength: 8,
                                obscureText: true,
                              ),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              Container(
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  color: Colors.green,
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      formKey.currentState!.save();
                                      try {
                                        await FirebaseAuth.instance
                                            .createUserWithEmailAndPassword(
                                          email: registerinfo.email,
                                          password: registerinfo.password,
                                        ).then((value) {
                                          formKey.currentState!.reset();
                                          Fluttertoast.showToast(
                                              msg: "สร้างบัญชีผู้ใช้สำเร็จ",
                                              gravity: ToastGravity.CENTER);
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()));
                                        });
                                      } on FirebaseAuthException catch (e) {
                                        print(e.code);
                                        // print(e.message);
                                        String message;
                                        if (e.code == 'email-already-in-use') {
                                          message =
                                              'อีเมลนี้ได้มีการลงทะเบียนไว้แล้ว กรุณาใช้อีเมลอื่น';
                                        } else if (e.code == 'weak-password') {
                                          message =
                                              'รหัสผ่านต้องมีความยาวไม่ต่ำกว่า 6 ตัวอักษร';
                                        } else {
                                          message = e.message!;
                                        }
                                        Fluttertoast.showToast(
                                            msg: message,
                                            gravity: ToastGravity.CENTER);
                                      }
                                      // print(
                                      //     "name = ${registerinfo.firstname} ${registerinfo.lastname},phone= ${registerinfo.phoneNumber},email= ${registerinfo.email},password= ${registerinfo.password}")
                                    }
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
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    required this.fieldKey,
    required this.hintText,
    required this.labelText,
    required this.helperText,
    required this.onSaved,
    required this.validator,
    required this.onFieldSubmitted,
  });

  final Key fieldKey;
  final String hintText;
  final String labelText;
  final String helperText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ValueChanged<String> onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 8,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        icon: Icon(Icons.lock, color: Colors.grey, size: 35),
        border: InputBorder.none,
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
