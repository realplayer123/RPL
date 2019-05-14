import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'isidatadiri.dart';
class DiriPage extends StatefulWidget {
  DiriPage(this.detailsUser);
  final UserDetails detailsUser;

  @override 
  DiriPageState createState() => DiriPageState();
}

class DiriPageState extends State<DiriPage> {

  File image;
  
  final String baseProfilePic =
      "https://www.shareicon.net/data/128x128/2017/02/07/878237_user_512x512.png";

  var url;

  @override 
  // ambil data dari cloud firestore
  Widget build(BuildContext context){

    final profpic = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: (image != null) ? Image.file(image,fit:BoxFit.fill):
              ((NetworkImage(widget.detailsUser.photoUrl) != null)
              ?(NetworkImage(widget.detailsUser.photoUrl))
              :NetworkImage(baseProfilePic)),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Diri"),
      ),
      body: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10),
                child: profpic,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 180.0),
                child: Text(
                  widget.detailsUser.userName, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23.0,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 210.0),
                child: Text(
                  widget.detailsUser.userEmail, 
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 22.0
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder(
            stream: Firestore.instance.collection('datadiri').where("email",isEqualTo : widget.detailsUser.userEmail ).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return new Container(child: Padding(
                  padding: EdgeInsets.only(top : 220.0),
                  child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return new KeteranganDiri(document : snapshot.data.documents);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 400.0),
            child: Center(
              child: RaisedButton(
                child: Text("Ubah Kata Sandi"),
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute( builder: (context) => LupaPage()),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 500.0),
            child: Center(
              child: RaisedButton(
                child: Text("Set Data Diri"),
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute( builder: (context) => IsiDiriPage(widget.detailsUser))
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class KeteranganDiri extends StatelessWidget {
  KeteranganDiri({this.document});
  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String nama = document[i].data['nama'].toString();
        String ktp = document[i].data['ktp'].toString();
        String jk = document[i].data['jk'].toString();
        String agama = document[i].data['agama'].toString();
        DateTime _lahir = document[i].data['lahir'];
        String lahir = "${_lahir.day}/${_lahir.month}/${_lahir.year}";

        return Padding(
          padding: const EdgeInsets.only(top : 260.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Nama :", style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("No KTP :", style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Gender :", style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Agama :", style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Lahir :", style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right :16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(nama, style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(ktp, style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(jk, style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(agama, style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                    new Padding(padding: EdgeInsets.only(top: 20.0),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(lahir, style: TextStyle(fontSize: 18.0),),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}