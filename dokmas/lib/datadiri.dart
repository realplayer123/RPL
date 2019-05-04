import 'package:flutter/material.dart';
import 'main.dart';
import 'isidatadiri.dart';
class DiriPage extends StatefulWidget {
  DiriPage(this.detailsUser);
  final UserDetails detailsUser;

  @override 
  DiriPageState createState() => DiriPageState();
}

class DiriPageState extends State<DiriPage> {
  @override 
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Diri"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 64.0),
          ),
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: new NetworkImage(widget.detailsUser.photoUrl),
                  fit: BoxFit.cover,
                )
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16.0),
          ),
          Center(
            child: Container(
              child: Text(
                widget.detailsUser.userName, 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8.0),
          ),
          Center(
            child: Container(
              child: Text(
                widget.detailsUser.userEmail, 
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(32.0,16.0,32.0,0),
            child: Row(
              children: <Widget>[
                Text("Nama Asli:"),
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                ),
                Expanded(
                  child: TextField(),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(32.0,16.0,32.0,0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: Text("Edit Data Diri"),
                    onPressed: () {
                      Navigator.push(context, 
                      MaterialPageRoute( builder: (context) => IsiDiriPage(widget.detailsUser))
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}