import 'main.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'datadiri.dart';
import 'dok.dart';

// Home Page
class HomePage extends StatelessWidget {
  static const routeName = '/home';

  // autentikasi disini
  UserDetails detailsUser;
  HomePage(this.detailsUser);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _gSignIn = new GoogleSignIn();
    void _signOutAll() async {
      await _firebaseAuth.signOut();
      await _gSignIn.signOut();
    }

    Widget mainDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountEmail: new Text(detailsUser.userEmail),
            accountName: new Text(detailsUser.userName),
            currentAccountPicture: new GestureDetector(
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(detailsUser.photoUrl),
              ),
            ),
            decoration: new BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Data Diri'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DiriPage(detailsUser)));
            },
          ),
          
          Divider(),
          ListTile(
            title: Text('Keluar'),
            onTap: () {
              _signOutAll();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
      ),
      drawer: mainDrawer,
      body: new DokPage(detailsUser),
    );
  }
}