import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'main.dart';

enum JenisKelamin { laki, perempuan }

class IsiDiriPage extends StatefulWidget {
  IsiDiriPage(this.detailsUser);
  final UserDetails detailsUser;
  @override
  IsiDiriPageState createState() => IsiDiriPageState();
}

class IsiDiriPageState extends State<IsiDiriPage> {
  TextEditingController nama = new TextEditingController();
  TextEditingController ktp = new TextEditingController();
  DateTime _lahir = new DateTime.now();
  String _lahirTeks = '';
  String agamaVal;
  JenisKelamin _jk = JenisKelamin.laki;
  String jk = 'Laki-laki';
  final formkey = new GlobalKey<FormState>();

  List<String> listagama =<String>[
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Budha',
    'Konghucu'
  ];

  File image;
  
  final String baseProfilePic =
      "https://www.shareicon.net/data/128x128/2017/02/07/878237_user_512x512.png";

  var url;

  bool gantiGambar= false;

  String validateDigit(String value) {
    Pattern pattern =
        r'^-?[0-9]+$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Data harus berupa bilangan';
    else
      return null;
  }

  String validateAlpha(String value) {
    Pattern pattern =
        r'^[a-zA-Z ]+$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Data harus berupa huruf';
    else
      return null;
  }

  Future<Null> _pilihLahir(BuildContext context) async {
    final pilih = await showDatePicker(
      context: context,
      firstDate: DateTime(1930),
      initialDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (pilih != null) {
      setState(() {
        _lahir = pilih;
        _lahirTeks = '${pilih.day}/${pilih.month}/${pilih.year}';
      });
    }
  }

  void _cariData() {
      final CollectionReference ref = Firestore.instance.collection('datadiri');
      Firestore.instance.runTransaction((Transaction tx) async {
        DocumentReference documentReference = ref.document(widget.detailsUser.userEmail);
        await tx.get(documentReference).then(
          (DocumentSnapshot snaps){
            nama.text = snaps.data['nama'];
            ktp.text = snaps.data['ktp'];
            agamaVal = snaps.data['agama'];
            print(snaps.data['jk']);
            print(snaps.data['agama']);
            print(snaps.data['lahir']);
          }
        );
    });
  }

  @override
  void initState() {
    super.initState();
    _lahirTeks = '${_lahir.day}/${_lahir.month}/${_lahir.year}';
    _cariData();
  }

  bool validasi() {
    final formnya = formkey.currentState;
    if(formnya.validate()){
      formnya.save();
      return true;
    }else{
      return false;
    }
  }

  Widget build(BuildContext context) {
    final profpic = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: (this.image != null) ? Image.file(image,fit:BoxFit.fill):
              ((NetworkImage(widget.detailsUser.photoUrl) != null)
              ?(NetworkImage(widget.detailsUser.photoUrl))
              :NetworkImage(baseProfilePic)),
        ),
      ),
    );

    Future getImage() async{
      var _img = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
       this.image = _img; 
       print('Image path $image');
      });
    }

    Future uploadPic(BuildContext context) async{
      String fileNama = basename(image.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileNama);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(image);
      var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      url = downUrl.toString();
      setState(() {
       print('Foto Profil Diubah');
       Scaffold.of(context).showSnackBar(SnackBar(content: Text('Foto Profil Diubah'),)); 
      });
    }

    void _editData() {
    if(gantiGambar) {
      print('Mencoba upload gambar...');
      uploadPic(context);
    }
    final CollectionReference ref = Firestore.instance.collection('datadiri');
    Firestore.instance.runTransaction((Transaction tx) async {
        DocumentReference documentReference = ref.document(widget.detailsUser.userEmail);
        await tx.set(documentReference, <String, dynamic> {
          'email' : widget.detailsUser.userEmail,
          'nama' : nama.text,
          'ktp' : ktp.text,
          'jk' : jk,
          'agama' : agamaVal,
          'lahir' : _lahir,
          'gambar' : url,
        });
    });
  }

    List<Widget> inputForm() {
      return [
        Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom :24.0, right: 8.0),
                  child: Text("Nama"),
                ),
                Expanded(
                  child: TextFormField(
                    validator: validateAlpha,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    maxLength: 32,
                    controller: nama,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 32.0, right: 32.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom :24.0, right: 8.0),
                  child: Text("No KTP"),
                ),
                Expanded(
                  child: TextFormField(
                    validator: validateDigit,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 20.0, left: 8.0, right: 8.0),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
                    ),
                    maxLength: 20,
                    controller: ktp,
                  ),
                ),
              ],
            ),
          ),
      ];
    } 

    return Scaffold(
      appBar: AppBar(
        title: Text("Set Data Diri"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top : 20.0, left: 20.0, right: 20.0),
            child: Text(
              "Perhatikan setiap data yang akan di set untuk ditampilkan sebagai informasi.",
              style: TextStyle(
                color: Colors.black45,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 100),
                child: profpic,
              ),
              Padding(
                padding: EdgeInsets.only(top: 160),
                child: IconButton(
                  icon: Icon(
                    Icons.camera,
                    size: 30.0,
                  ),
                  onPressed: (){
                    getImage();
                  },
                )
              ),
            ],
          ),
          Form(
            key: formkey,
            child: Column(
              children: inputForm(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
            child: Row(
              children: <Widget>[
                Expanded(child: Text("Tanggal Lahir :")),
                FlatButton(
                    onPressed: () => _pilihLahir(context),
                    child: Text(_lahirTeks)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
            child: Row(
              children: <Widget>[
                Text("Jenis Kelamin : "),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 32.0, right: 32.0),
              child: Column(
                children: <Widget>[
                  RadioListTile<JenisKelamin>(
                    title: const Text('Laki-laki'),
                    value: JenisKelamin.laki,
                    groupValue: _jk,
                    onChanged: (JenisKelamin value) {
                      setState(() {
                        jk = 'Laki-laki';
                        _jk = value;
                      });
                    },
                  ),
                  RadioListTile<JenisKelamin>(
                    title: const Text('Perempuan'),
                    value: JenisKelamin.perempuan,
                    groupValue: _jk,
                    onChanged: (JenisKelamin value) {
                      setState(() {
                        jk = 'Perempuan';
                        _jk = value;
                      });
                    },
                  ),
                ],
              )),
          Padding(
            padding: const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
            child: Row(
              children: <Widget>[
                Text("Agama : "),
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                ),
                DropdownButton(
                  items: listagama.map((value)=>DropdownMenuItem(
                    child: Text(
                      value,
                    ),
                    value: value,  
                  )).toList(),
                  onChanged: (selectedAgama){
                    setState(() {
                      agamaVal = selectedAgama;
                    });
                  },
                  value: agamaVal,
                  hint: Text("Apa agama Anda?"),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
            padding: EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
            child: RaisedButton(
              onPressed: () {
                if(validasi()){
                  _editData();
                  Navigator.pop(context);
                }
              },
              child: Text("Set Data"),
            ),
          )),
        ],
      ),
    );
  }
}
