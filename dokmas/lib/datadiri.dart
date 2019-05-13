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
                padding: EdgeInsets.only(top: 150.0),
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
                  padding: EdgeInsets.only(top : 200.0),
                  child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return new KeteranganDiri(document : snapshot.data.documents);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 240.0),
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
          Padding(
            padding: const EdgeInsets.only(top: 350.0),
            child: Center(
              child: RaisedButton(
                child: Text("UBAH KATA SANDI"),
                onPressed: () {
                  Navigator.push(context, 
                  MaterialPageRoute( builder: (context) => LupaPage()),
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
        String lahir = document[i].data['lahir'].toString();
        
        return Padding(
          padding: const EdgeInsets.only(top : 200.0),
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