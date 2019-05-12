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

  @override 
  // ambil data dari cloud firestore
  Widget build(BuildContext context){
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
                padding: EdgeInsets.only(top: 100),
                height: 100,
                width: 100,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: new NetworkImage(widget.detailsUser.photoUrl),
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 120.0),
                child: Text(
                  widget.detailsUser.userName, 
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 140.0),
                child: Text(
                  widget.detailsUser.userEmail, 
                  style: TextStyle(
                    color: Colors.black54,
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
                  padding: EdgeInsets.only(top : 200.0),
                  child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return new KeteranganDiri(document : snapshot.data.documents);
            },
          ),
          Center(
            child: RaisedButton(
              child: Text("Set Data Diri"),
              onPressed: () {
                Navigator.push(context, 
                MaterialPageRoute( builder: (context) => IsiDiriPage(widget.detailsUser))
                );
              },
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
        String lahir = document[i].data['lahir'].toString();
        
        return Padding(
          padding: const EdgeInsets.only(top : 180.0),
          child: Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left : 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Nama :"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("No KTP :"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Seks :"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Agama :"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Lahir :"),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(nama),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(ktp),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(jk),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(agama),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(lahir),
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