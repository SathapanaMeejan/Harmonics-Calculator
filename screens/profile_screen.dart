import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:harmonicsv2/models/profile_informations.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final formKey = GlobalKey<FormState>();

  ProfileInformations registerinfo =
      ProfileInformations(firstname: '', lastname: '', phoneNumber: '');

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
                  backgroundColor: Colors.redAccent,
                  title: Text(
                    "Profile",
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
                      colors: [Colors.yellowAccent, Colors.red],
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
                              
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 35,
                                  ),
                                  labelText: "FirstName",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                                onSaved: (String? value) {
                                  registerinfo.firstname = value!.trim();
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please Fill Your First Name in the Blank';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                    size: 35,
                                  ),
                                  labelText: "LastName",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                                onSaved: (String? value) {
                                  registerinfo.lastname = value!.trim();
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please Fill Your Last Name in the Blank';
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  filled: true,
                                  icon: Icon(
                                    Icons.phone,
                                    color: Colors.grey,
                                    size: 35,
                                  ),
                                  labelText: "Phone Number",
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 20,
                                  ),
                                ),
                                onSaved: (String? value) {
                                  registerinfo.phoneNumber = value!.trim();
                                },
                                validator: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Please Fill Your Phone Number in the Blank';
                                  } else {
                                    return null;
                                  }
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                              SizedBox(
                                height: 10,
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
                                  color: Colors.redAccent,
                                  onPressed: () {},
                                  child: Text(
                                    "Save Profile",
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
