import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'login.dart';
import 'daftar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        "/": (context) => LoginPage(),
        "/daftar": (context) => SignUpPage(),
      },
    );
  }
}

class UserDetails {
  final String userName;
  final String photoUrl;
  final String userEmail;
  UserDetails(this.userName, this.photoUrl, this.userEmail);
}
