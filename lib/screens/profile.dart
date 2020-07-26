import 'dart:io';

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
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flutter_crud_lessons_app/models/user.dart';
import 'package:flutter_crud_lessons_app/services/database.dart';

class Profile extends StatefulWidget {
  final user;

  Profile({this.user});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _profileFormKey = GlobalKey<FormState>();

  final _namecontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _confirmpasswordcontroller = TextEditingController();
  final _userImageontroller = TextEditingController();
  bool loading = false;
  String error = "";
  final _auth = AuthService();
  User user;
  File _image;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future getUser() async {
      var currentUser = await DatabaseService().getProfile(widget.user.uid);

      setState(() {
        user = currentUser;
        _namecontroller.text = currentUser.name;
        _userImageontroller.text = currentUser.UserImage;
      });
      getUser();
    }
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _passwordcontroller.dispose();
    _userImageontroller.dispose();
    _confirmpasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future getUser() async {
      var currentUser = await DatabaseService().getProfile(widget.user.uid);

      setState(() {
        user = currentUser;
      });
    }

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });
    }

    Future uploadImage() async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);

      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      var url = await (await uploadTask.onComplete).ref.getDownloadURL();
      _userImageontroller.text = url.toString();
      print("pic uploaded");

      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Img uploaded"),
      ));
    }

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
            ),
            body: Form(
              key: _profileFormKey,
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
                      CircleAvatar(
                          radius: 100,
                          backgroundColor: Colors.cyanAccent,
                          child: (_image != null)
                              ? Image.file(
                                  _image,
                                  fit: BoxFit.fill,
                                )
                              : (_userImageontroller.text != "")
                                  ? Image.network(
                                      _userImageontroller.text,
                                      fit: BoxFit.fill,
                                    )
                                  : Text("no image uploaded yet")),
                      SizedBox(
                        height: 10,
                      ),
                      IconButton(
                        icon: Icon(Icons.camera),
                        onPressed: () {
                          getImage();
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.red,
                            onPressed: () {
                              uploadImage();
                            },
                            child: Text("Upload"),
                          ),
                          RaisedButton(
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("iptal"),
                          ),
                        ],
                      ),
                      RaisedButton(
                        child: Text("Güncelle"),
                        onPressed: () async {
                          if (_profileFormKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            try {
                              await DatabaseService(uid: widget.user.uid)
                                  .editProfile(
                                      widget.user.uid,
                                      _namecontroller.text,
                                      _userImageontroller.text);

                              if (_passwordcontroller.text.isNotEmpty) {
                                FirebaseUser updatedUser =
                                    await FirebaseAuth.instance.currentUser();
                                updatedUser
                                    .updatePassword(_passwordcontroller.text)
                                    .then((_) {
                                  setState(() {
                                    loading = false;
                                  });
                                }).catchError((e) {
                                  print(e);
                                });
                              }
                              Navigator.pop(context);
                            } catch (e) {
                              print(e);
                              setState(() {
                                loading = false;
                              });
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
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
