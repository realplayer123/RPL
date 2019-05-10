import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditData extends StatefulWidget{
  EditData({this.jenis, this.deskripsi, this.gambar, this.nomor, this.index});
  final String nomor;
  final String jenis;
  final String deskripsi;
  final String gambar;
  final index;

  @override
  _EditDataState createState() => new _EditDataState();
}

class _EditDataState extends State<EditData>{
  String jenis;

  TextEditingController controllerNomor;
  TextEditingController controllerDeskripsi;

  File _image;
  String no;
  String desk;
  var url;
  bool gantiGambar;

  picker() async{
    gantiGambar = true;
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if(image!=null){
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }
  }

  Future uploadPic() async{
    String fileName = basename(_image.path);
    StorageReference firebaseStoragRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStoragRef.putFile(_image);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = downUrl.toString();
  }

void _edit(){
  
  if(gantiGambar) {
    
  }

  Firestore.instance.runTransaction((Transaction transaction) async{
    DocumentSnapshot snapshot =
    await transaction.get(widget.index);
    await transaction.update(snapshot.reference,{
      "jenis": jenis,
      "deskripsi": desk,
      "nomor" : no,
      "gambar": url,
    });
    print("url yang di upload itu ini $url");
  });
}

@override
void initState(){
  super.initState();
  gantiGambar = false;
  jenis = widget.jenis;
  desk = widget.deskripsi;
  controllerDeskripsi = new TextEditingController(text: widget.deskripsi);
  controllerNomor = new TextEditingController(text: widget.nomor);
  no = widget.nomor;
  url = widget.gambar;
  
}

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        //leading: new Icon(Icons, list) buat icon
        title: new Text("Edit Document"),
        backgroundColor: Colors.indigo,
      ),
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.all(10),
              child: new Column(
                children: <Widget>[
                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                  new Container(
                        padding: EdgeInsets.only(top: 10.0, right: 32.0, left: 32.0),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: _image == null ? new Image.network(url,) : new Image.file(_image),
                          ),
                        ),
                      ),
                  new Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Jenis Dokumen: ", style:  new TextStyle(fontSize: 20.0, color: Colors.black87)),
                      ),
                      new SizedBox(width: 20.0,),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownButton(
                          value: jenis,
                          onChanged: (String jenisBaru) {
                            setState(() {
                              jenis = jenisBaru;
                            });
                          },
                          items: <String>[
                            'KTP',
                            'KK',
                            'SIM',
                            'Paspor',
                            'STNK',
                            'Akta Kelahiran',
                          ].map<DropdownMenuItem<String>>((String val) {
                            return DropdownMenuItem<String>(
                              child: Text(val),
                              value: val,
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),

                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                  new TextField(
                    controller: controllerNomor,
                    onChanged: (String s){
                      setState(() {
                        no = s;
                      });
                    },
                    decoration: new InputDecoration(
                      labelText: "Nomor",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(20.0)
                      )
                    ),
                  ),
                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                  new TextField(
                    maxLines: 5,
                    controller: controllerDeskripsi,
                    onChanged: (String s){
                      setState(() {
                        desk = s;
                      });
                    },
                    decoration: new InputDecoration(
                      labelText: "Deskripsi",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(20.0)
                      )
                    ),
                  ),

                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                  
                  new RaisedButton(
                    child: new Text("Ganti"),
                    onPressed: (){
                      _edit();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
            onPressed: picker, 
            tooltip: 'Pick Image',
            child: new Icon(Icons.camera),
      )
    );
  }
}