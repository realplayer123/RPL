import 'package:flutter/material.dart';

class DiriPage extends StatefulWidget {
  @override 
  DiriPageState createState() => DiriPageState();
}

class DiriPageState extends State<DiriPage> {
  @override 
  final String _nama= "Hilmy";
  
  final barisNama = TextField(
    onChanged: (text) {
      _nama : text;
    },
  );

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Diri"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
            child: Text("Namaowowow : ${_nama}"),
          ),
          Container(
            padding: EdgeInsets.only(left: 32.0, right: 32.0),
            child: TextField(),
          ),
        ],
      ),
    );
  }
}