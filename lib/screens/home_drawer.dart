import 'package:flutter/material.dart';
import 'package:flutter_crud_lessons_app/main.dart';
import 'package:flutter_crud_lessons_app/screens/login.dart';
import 'package:flutter_crud_lessons_app/screens/my_posts.dart';
import 'package:flutter_crud_lessons_app/screens/profile.dart';
import 'package:flutter_crud_lessons_app/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_crud_lessons_app/services/auth.dart';
import 'package:flutter_crud_lessons_app/shared/state.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class HomeDrawer extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    // final bool isAuthenticated = Provider.of<GlobalState>(context).isAuthenticated;
    final user = Provider.of<FirebaseUser>(context);
    final bool isAuthenticated = user != null;
    String email = "";

    if (isAuthenticated) {
      email = user.email;
    } else {
      email = "Anonim";
    }
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(
                "${email}",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(user: user),
                  ),
                );
              },
            ),
            decoration: BoxDecoration(color: Colors.blue),
          ),
          if (!isAuthenticated) ...[
            ListTile(
              title: Text("Login"),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
            ),
          ],
          if (isAuthenticated) ...[
            ListTile(
              title: Text("Postlarım"),
              leading: Icon(Icons.local_post_office),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPosts(user: user),
                  ),
                );
              },
            ),
          ],
          if (isAuthenticated) ...[
            ListTile(
              title: Text("Sign Out"),
              leading: Icon(Icons.exit_to_app),
              onTap: () async {
                await _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
            ),
          ],
          if (!isAuthenticated) ...[
            ListTile(
              title: Text("Register"),
              leading: Icon(Icons.account_circle),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}
