import 'package:flutter/material.dart';
import 'package:flutter_crud_lessons_app/models/post.dart';
import 'package:flutter_crud_lessons_app/models/user.dart';
import 'package:flutter_crud_lessons_app/screens/home.dart';
import 'package:flutter_crud_lessons_app/screens/login.dart';
import 'package:flutter_crud_lessons_app/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crud_lessons_app/services/auth.dart';
import 'package:flutter_crud_lessons_app/services/database.dart';
import 'package:flutter_crud_lessons_app/shared/state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAuthenticated = false;
  String testProviderText = "Merhaba Provider!";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.onAuthStateChanged.listen((user) {
      print("onAuthStatchange workd");

      setState(() {
        isAuthenticated = user != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<String>(create: (context) => testProviderText),
        // ChangeNotifierProvider<GlobalState>(create: (context) => GlobalState()),
        StreamProvider<FirebaseUser>(
            create: (context) => FirebaseAuth.instance.onAuthStateChanged),
        StreamProvider<User>.value(value: AuthService().user),
        StreamProvider<List<Post>>(
            create: (context) => DatabaseService().posts),
      ],
      child: MaterialApp(
        title: 'Flutter crud lessons',
        home: Home(),
      ),
    );
  }
}
