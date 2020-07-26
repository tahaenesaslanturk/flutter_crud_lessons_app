import 'package:flutter/material.dart';
import 'package:flutter_crud_lessons_app/models/post.dart';
import 'package:flutter_crud_lessons_app/screens/edit_post.dart';
import 'package:flutter_crud_lessons_app/screens/show_posts.dart';
import 'package:flutter_crud_lessons_app/services/database.dart';
import 'package:flutter_crud_lessons_app/shared/loading.dart';

class MyPosts extends StatefulWidget {
  final user;

  MyPosts({this.user});
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyPosts"),
      ),
      body: Center(
        child: StreamBuilder(
          stream: DatabaseService(uid: widget.user.uid).individualPosts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> posts = snapshot.data;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(posts[index].title),
                    subtitle: Text(posts[index].content),
                    trailing: PopupMenuButton(
                      onSelected: (result) async {
                        final type = result["type"];
                        final post = result["value"];
                        switch (type) {
                          case "edit":
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPost(post: post),
                              ),
                            );
                            break;
                          case "delete":
                            DatabaseService(uid: widget.user.uid)
                                .deletePost(post.id);
                            break;
                        }
                      },
                      itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: {"type": "edit", "value": posts[index]},
                          child: Text("Edit"),
                        ),
                        PopupMenuItem(
                          value: {"type": "delete", "value": posts[index]},
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShowPosts(post: posts[index]),
                        ),
                      );
                    },
                  );
                },
              );
            } else {
              return Loading();
            }
          },
        ),
      ),
    );
  }
}
