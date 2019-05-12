import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'dokisi.dart';
import 'dokedit.dart';
class DokPage extends StatefulWidget {
  DokPage(this.detailsUser);
  final UserDetails detailsUser;
  @override
  _DokPageState createState() => new _DokPageState();
}

class _DokPageState extends State<DokPage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => DokisiPage(widget.detailsUser)
            )
          );
        },
      ),
      body: StreamBuilder(
            stream: Firestore.instance.collection('dokumen').where("email",isEqualTo : widget.detailsUser.userEmail ).snapshots(),
            builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return new Container(child: Padding(
                  padding: EdgeInsets.only(top : 100.0),
                  child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return new DokumenList(document : snapshot.data.documents);
            },
          ),
    );
  }
}
class DokumenList extends StatelessWidget {
  DokumenList({this.document});
  final List<DocumentSnapshot> document;
  
  @override
  Widget build(BuildContext context) {
    print(document.length);
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int i){
        String jenis = document[i].data['jenis'].toString();
        String deskripsi = document[i].data['deskripsi'].toString();
        String gambar = document[i].data['gambar'].toString();
        String nomor = document[i].data['nomor'].toString();
        
        return Dismissible(
          key: new Key(document[i].documentID),
          onDismissed: (direction){
            Firestore.instance.runTransaction((transaction) async{
              DocumentSnapshot snapshot =
              await transaction.get(document[i].reference);
              await transaction.delete(snapshot.reference);
            });

            Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Dokumen berhasil dihapus"),)
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              
              children: <Widget>[
                new IconButton(
                  color: Colors.lightBlue,
                  icon: Icon(Icons.edit),
                  onPressed: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                      builder: (BuildContext context)=>new EditData(
                        jenis: jenis,
                        deskripsi: deskripsi,
                        gambar: gambar,
                        nomor: nomor,
                        index: document[i].reference,
                      )
                    ));
                  },
                ),
                new Expanded(
                  child: Container(
                    color: Colors.lightBlueAccent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left : 32.0, top: 16.0, bottom: 4.0,),
                          child: Text(jenis, textAlign: TextAlign.left, style: new TextStyle(fontSize: 20.0, letterSpacing: 1.0, fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left : 32.0, bottom: 24.0),
                          child: Text(nomor, textAlign: TextAlign.left, style: new TextStyle(fontSize: 10.0, letterSpacing: 1.0),),
                        ),
                        
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}