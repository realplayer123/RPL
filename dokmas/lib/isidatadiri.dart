import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

enum JenisKelamin { laki, perempuan }

class IsiDiriPage extends StatefulWidget {
  IsiDiriPage(this.detailsUser);
  final UserDetails detailsUser;
  
  @override
  IsiDiriPageState createState() => IsiDiriPageState();
}

class IsiDiriPageState extends State<IsiDiriPage> {
  String nama = '';
  String ktp = '';
  
  void _editData() {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection("datadiri");
      await reference.add({
        "email" : widget.detailsUser.userEmail,
        "nama" : nama,
        "noktp" : ktp,
        "jk" : _jk,
        "agama" : agamaVal,
        "ttl" : _lahir,
      });
    });
    Navigator.pop(context);
  }

  DateTime _lahir = new DateTime.now();
  String _lahirTeks = '';
  Future<Null> _pilihLahir(BuildContext context) async {
    final pilih = await showDatePicker(
      context: context,
      firstDate: DateTime(1930),
      initialDate: DateTime.now(),
      lastDate: DateTime(2020),
    );

    if (pilih != null) {
      setState(() {
        _lahir = pilih;
        _lahirTeks = '${pilih.day}/${pilih.month}/${pilih.year}';
      });
    }
  }

  String agamaVal = 'Islam';
  JenisKelamin _jk = JenisKelamin.laki;

  @override
  void initState() {
    super.initState();
    _lahirTeks = '${_lahir.day}/${_lahir.month}/${_lahir.year}';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data Diri"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
            child: Row(
              children: <Widget>[
                Text("Nama :"),
                Expanded(
                  child: TextField(
                    onChanged: (String str) {
                      setState(() {
                        nama = str;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 32.0, right: 32.0),
            child: Row(
              children: <Widget>[
                Text("No KTP :"),
                Expanded(
                  child: TextField(
                    onChanged: (String str) {
                      setState(() {
                        ktp = str;
                      });
                    },
                  ),
                ),
              ],
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
                  value: agamaVal,
                  onChanged: (String agamaValBaru) {
                    setState(() {
                      agamaVal = agamaValBaru;
                    });
                  },
                  items: <String>[
                    'Islam',
                    'Kristen',
                    'Katolik',
                    'Hindu',
                    'Budha',
                    'Konghucu'
                  ].map<DropdownMenuItem<String>>((String val) {
                    return DropdownMenuItem<String>(
                      child: Text(val),
                      value: val,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Center(
              child: Padding(
            padding: EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
            child: RaisedButton(
              onPressed: () {
                _editData();
              },
              child: Text("Edit"),
            ),
          )),
        ],
      ),
    );
  }
}
