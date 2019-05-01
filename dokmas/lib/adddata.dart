import 'package:flutter/material.dart';

class Adddoc extends StatefulWidget{
  @override
  _AdddocState createState() => new _AdddocState();
}

class _AdddocState extends State<Adddoc>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
        //leading: new Icon(Icons, list) buat icon
        title: new Text("Tambah Dokumen"),
        backgroundColor: Colors.indigo,
      ),
      body: Material(
        child: Column(
          children: <Widget>[
            Container(
              
            )
          ],
        )
      )
    );
  }
}