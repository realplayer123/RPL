import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class DokisiPage extends StatefulWidget {
  DokisiPage(this.detailsUser);
  final UserDetails detailsUser;
  @override
  _DokisiPageState createState() => new _DokisiPageState();
}

class _DokisiPageState extends State<DokisiPage> {
  String jenis = 'KTP';
  String deskrip = '';
  TextEditingController nomor = new TextEditingController();
  String url = '';
  File _image;
  final formkeydok = new GlobalKey<FormState>();

  Future picker() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }
  }

  void uploadPic() async {
    String fileName = basename(_image.path);
    StorageReference firebaseStoragRef =
        FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = firebaseStoragRef.putFile(_image);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    var url = downUrl.toString();

    Firestore.instance.runTransaction((Transaction transaksi) async {
      CollectionReference reference = Firestore.instance.collection('dokumen');
      await reference.add({
        "email": widget.detailsUser.userEmail,
        "jenis": jenis,
        "deskripsi": deskrip,
        "nomor": nomor.text,
        "gambar": url,
      });
    });
  }

  String validateDigit(String value) {
    Pattern pattern =
        r'^-?[0-9]+$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Data harus berupa bilangan';
    else
      return null;
  }

  void _add() {
    if (_image != null) {
      uploadPic();
    } else {
      String urldeff =
          "https://cdn0.iconfinder.com/data/icons/thin-files-documents/57/thin-064_paper_document_file_word_copy_archive-512.png";

      Firestore.instance.runTransaction((Transaction transaksi) async {
        CollectionReference reference =
            Firestore.instance.collection('dokumen');
        await reference.add({
          "email": widget.detailsUser.userEmail,
          "jenis": jenis,
          "deskripsi": deskrip,
          "nomor": nomor.text,
          "gambar": urldeff,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Dokumen Baru"),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 300,
            width: 200,
            child: Center(
              child: _image == null
                  ? new Text(
                      "Tidak Ada Gambar",
                      style: TextStyle(fontSize: 18),
                    )
                  : new FittedBox(
                      child: new Image.file(
                        _image,
                        fit: BoxFit.fitWidth,
                      ),
                      fit: BoxFit.fitWidth,
                    ),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text("Jenis : "),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
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
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32.0, bottom: 16.0),
                child: Text("Nomor : "),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 64.0, bottom: 16.0),
                  width: 10.0,
                  child: Form(
                    key: formkeydok,
                    child: TextFormField(
                      controller: nomor,
                      validator: validateDigit,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 32.0, bottom: 16.0),
                child: Text("Deskripsi : "),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(right: 64.0, bottom: 16.0),
                  width: 10.0,
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                    onChanged: (String str) {
                      setState(() {
                        deskrip = str;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: new RaisedButton(
              child: new Text("Tambah"),
              onPressed: () {
                if (formkeydok.currentState.validate()) {
                  formkeydok.currentState.save();
                  _add();
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: picker,
        tooltip: 'Pilih Gambar',
        child: new Icon(Icons.camera),
      ),
    );
  }
}
