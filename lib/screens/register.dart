import 'package:flutter/material.dart';
import 'package:flutter_crud_lessons_app/main.dart';
import 'package:flutter_crud_lessons_app/screens/home.dart';
import 'package:flutter_crud_lessons_app/screens/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_crud_lessons_app/services/auth.dart';
import 'package:flutter_crud_lessons_app/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crud_lessons_app/shared/loading.dart';
import 'package:flutter_crud_lessons_app/shared/state.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _registerFormKey = GlobalKey<FormState>();

  final _namecontroller = TextEditingController();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  bool loading = false;
  String error = "";
  final _auth = AuthService();
  @override
  void dispose() {
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Register"),
            ),
            body: Form(
              key: _registerFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "isim"),
                        controller: _namecontroller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen isim giriniz";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "email"),
                        controller: _emailcontroller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen email giriniz";
                          } /*else if (!EmailValidator.validate(value)) {
                      return "Lütfen geçerli bir email giriniz";
                    }*/
                          else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "şifre"),
                        controller: _passwordcontroller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen şifre giriniz";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                            hintText: "şifre tekrar"),
                        controller: _confirmpasswordcontroller,
                        validator: (value) {
                          if (value != _passwordcontroller.text) {
                            return "Şifreleriniz uyuşmuyor";
                          } else {
                            return null;
                          }
                        },
                      ),
                      RaisedButton(
                        child: Text("Register"),
                        onPressed: () async {
                          if (_registerFormKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            try {
                              // register user by firebase auth
                              final FirebaseUser user =
                                  await _auth.registerWithEmailAndPassword(
                                _namecontroller.text,
                                _emailcontroller.text,
                                _passwordcontroller.text,
                              );
                              if (user != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()));
                              } else {
                                setState(() {
                                  error = "Bilgilerinizi kontrol ediniz!";
                                  loading = false;
                                });
                              }
                            } catch (e) {
                              print(e);
                            }
                          } else {}
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Do you have an account?"),
                      FlatButton(
                        child: Text("Login"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Login(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
