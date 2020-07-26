import 'package:flutter/material.dart';
import 'package:flutter_crud_lessons_app/main.dart';
import 'package:flutter_crud_lessons_app/screens/home.dart';
import 'package:flutter_crud_lessons_app/screens/login.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_crud_lessons_app/screens/register.dart';
import 'package:flutter_crud_lessons_app/services/auth.dart';
import 'package:flutter_crud_lessons_app/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crud_lessons_app/shared/loading.dart';
import 'package:flutter_crud_lessons_app/shared/state.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _auth = AuthService();

  bool loading = false;
  String error = "";
  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Login"),
            ),
            body: Form(
              key: _loginFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
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
                      RaisedButton(
                        child: Text("Login"),
                        onPressed: () async {
                          if (_loginFormKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            try {
                              // login user by firebase auth
                              final FirebaseUser user =
                                  await _auth.loginWithEmailAndPassword(
                                      _emailcontroller.text,
                                      _passwordcontroller.text);
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
                          }
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
                      Text("Don't you have an account?"),
                      FlatButton(
                        child: Text("Register"),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Register(),
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
