import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_lessons_app/models/post.dart';
import 'package:flutter_crud_lessons_app/screens/home_drawer.dart';
import 'package:flutter_crud_lessons_app/screens/login.dart';
import 'package:flutter_crud_lessons_app/screens/new_post.dart';
import 'package:flutter_crud_lessons_app/screens/show_posts.dart';
import 'package:flutter_crud_lessons_app/shared/state.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    // final bool isAuthenticated = Provider.of<GlobalState>(context).isAuthenticated;
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;
    final posts = Provider.of<List<Post>>(context) ?? [];
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: Text("Home Page"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              posts[index].title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(posts[index].content),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowPosts(post: posts[index]),
                  ));
            },
          );
        },
        itemCount: posts.length,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isAuthenticated ? "Yeni post" : "Giriş yap",
        child: isAuthenticated ? Icon(Icons.note_add) : Icon(Icons.exit_to_app),
        onPressed: () {
          if (isAuthenticated) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NewPost()));
          } else {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Login()));
          }
        },
      ),
    );
  }
}
