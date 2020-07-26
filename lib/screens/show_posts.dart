import 'package:flutter/material.dart';
import 'package:flutter_crud_lessons_app/models/post.dart';

class ShowPosts extends StatefulWidget {
  final Post post;
  ShowPosts({this.post});
  @override
  _ShowPostsState createState() => _ShowPostsState();
}

class _ShowPostsState extends State<ShowPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("ShowPosts"),
        ),
        body: Card(
          color: Colors.cyanAccent,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: ListTile(
            title: Text(
              "${widget.post.title}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${widget.post.content}"),
          ),
        ));
  }
}
