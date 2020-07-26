import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_lessons_app/models/post.dart';
import 'package:flutter_crud_lessons_app/screens/edit_post.dart';
import 'package:flutter_crud_lessons_app/screens/show_posts.dart';
import 'package:flutter_crud_lessons_app/services/database.dart';
import 'package:flutter_crud_lessons_app/shared/constants.dart';
import 'package:flutter_crud_lessons_app/shared/loading.dart';
import 'package:provider/provider.dart';

class EditPost extends StatefulWidget {
  final Post post;

  EditPost({this.post});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _editPostFormKey = GlobalKey<FormState>();

  bool loading = false;
  String error = "";
  final _titlecontroller = TextEditingController();
  final _contentcontroller = TextEditingController();

  void dispose() {
    _titlecontroller.dispose();
    _contentcontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titlecontroller.text = widget.post.title;
    _contentcontroller.text = widget.post.content;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);

    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("EditPost"),
            ),
            body: Form(
              key: _editPostFormKey,
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
                        child: Text("Update Post"),
                        onPressed: () async {
                          if (_editPostFormKey.currentState.validate()) {
                            setState(() {
                              loading = true;
                            });
                            try {
                              // login user by firebase auth
                              final user = Provider.of<FirebaseUser>(context,
                                  listen: false);
                              dynamic result =
                                  await DatabaseService(uid: user.uid).editPost(
                                      widget.post.id,
                                      _titlecontroller.text,
                                      _contentcontroller.text);
                              if (result != null) {
                                Navigator.pop(context);
                                loading = false;
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
