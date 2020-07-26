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
import 'package:flutter_crud_lessons_app/services/database.dart';
import 'package:provider/provider.dart';

class NewPost extends StatefulWidget {
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _newPostFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = "";
  final _titlecontroller = TextEditingController();
  final _contentcontroller = TextEditingController();
  final _db = DatabaseService();

  void dispose() {
    _titlecontroller.dispose();
    _contentcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("NewPost"),
            ),
            body: Form(
              key: _newPostFormKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "title"),
                        controller: _titlecontroller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen başlık giriniz";
                          } else {
                            return null;
                          }
                        },
                      ),
                      TextFormField(
                        decoration:
                            textInputDecoration.copyWith(hintText: "içerik"),
                        controller: _contentcontroller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Lütfen içerik giriniz";
                          } else {
                            return null;
                          }
                        },
                      ),
                      RaisedButton(
                        child: Text("Post"),
                        onPressed: () async {
                          if (_newPostFormKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            try {
                              // login user by firebase auth
                              final user = Provider.of<FirebaseUser>(context,
                                  listen: false);
                              dynamic result = await _db.createPost(
                                  user.uid,
                                  _titlecontroller.text,
                                  _contentcontroller.text);
                              if (result != null) {
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
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
