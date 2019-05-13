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
        print('ganti gambar : $gantiGambar');
      });
    }
  }

  Future uploadPic() async{
    
    String fileName = basename(_image.path);
    StorageReference firebaseStoragRef = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStoragRef.putFile(_image);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    url = downUrl.toString();
    print('Upload gambar berlangsung...');
    Firestore.instance.runTransaction((Transaction transaction) async{
      DocumentSnapshot snapshot =
      await transaction.get(widget.index);
      await transaction.update(snapshot.reference,{
        "gambar": url,
      });
      print("url yang di upload itu ini $url");
    });
  }

void _edit(){
  print('di sini ganti gambar : $gantiGambar');
  if(gantiGambar) {
    print('Mencoba upload gambar...');
    uploadPic();
  }

  Firestore.instance.runTransaction((Transaction transaction) async{
    DocumentSnapshot snapshot =
    await transaction.get(widget.index);
    await transaction.update(snapshot.reference,{
      "jenis": jenis,
      "deskripsi": desk,
      "nomor" : no,
      "scan": url,
    });
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
        title: new Text("Lihat Dokumen"),
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
                        width: double.infinity,
                        child: PhotoHero(
                          photo: _image,
                          width: 100,
                          url: url,
                          onTap: (){
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context){
                                  return Scaffold(
                                    body: Container(
                                      color: Colors.white,
                                      child: Center(
                                        child: PhotoHero(
                                          photo: _image,
                                          width: double.infinity,
                                          url: url,
                                          onTap: (){
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              )
                            );
                          },
                        ),
                      ),
                  new Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Jenis Dokumen :", style:  new TextStyle(fontSize: 20.0, color: Colors.black87)),
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
                    child: new Text("Ubah Dokumen"),
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

class PhotoHero extends StatelessWidget {
  const PhotoHero({ Key key, this.photo, this.onTap, this.width, this.url }) : super(key: key);

  final File photo;
  final VoidCallback onTap;
  final double width;
  final String url;

  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: "dokumen",
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: photo == null ? Image.network(url) : Image.file(photo),
          ),
        ),
      ),
    );
  }
}