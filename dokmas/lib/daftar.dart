import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'homepage.dart';
import 'main.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final String currentProfilePic =
      "https://www.shareicon.net/data/128x128/2017/02/07/878237_user_512x512.png";

  TextEditingController controllerPass = new TextEditingController();
  TextEditingController controllerPassCek = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerUsername = new TextEditingController();

  void _daftarBaru(BuildContext cont) async {
    try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: controllerEmail.text,
      password: controllerPass.text,
    );

    Firestore.instance.runTransaction((Transaction tx) async {
      DocumentReference documentReference = Firestore.instance
          .collection('pengguna')
          .document(controllerEmail.text);
      await tx.set(documentReference, <String, dynamic>{
        "email": controllerEmail.text,
        "username": controllerUsername.text,
      });
    });

    // pindah ke HomePage
    UserDetails userbaru = new UserDetails(
        controllerUsername.text, currentProfilePic, controllerEmail.text);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => HomePage(userbaru)));
    } catch(e) {
      print('Wadididadaw ada error : $e');
      Scaffold.of(cont).showSnackBar(
        new SnackBar(content: Text('Gagal mendaftarkan akun, cek kembali data yang di masukan'),)
      );
    }
  }

  AlertDialog submit() {
    AlertDialog alertDialog = new AlertDialog(
        content: new Container(
      height: 260.0,
      child: new Column(
        children: <Widget>[
          new Text("Email : ${controllerEmail.text}"),
          new Text("Kata Sandi : ${controllerPass.text}"),
        ],
      ),
    ));
    return alertDialog;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        //leading: new Icon(Icons, list) buat icon
        title: new Text("Daftar Akun Baru"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Builder(
        builder: (BuildContext cont) => ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                  child: Center(
                    child: Text("Masukan Email"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                  child: TextField(
                    controller: controllerEmail,
                    decoration: InputDecoration(
                      hintText: "Email",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                  child: Center(
                    child: Text("Masukan Username"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                  child: TextField(
                    controller: controllerUsername,
                    decoration: InputDecoration(
                      hintText: "Username",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, bottom: 8.0),
                  child: Center(
                    child: Text("Masukan Kata Sandi"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                  child: TextField(
                    obscureText: true,
                    controller: controllerPass,
                    decoration: InputDecoration(
                      hintText: "Kata Sandi",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 32.0, right: 32.0),
                  child: TextField(
                    obscureText: true,
                    controller: controllerPassCek,
                    decoration: InputDecoration(
                      hintText: "Ulangi Kata Sandi",
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 32.0, right: 32.0),
                  child: Container(
                    height: 48,
                    child: RaisedButton(
                      child: Text(
                        "Daftar",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blueAccent,
                      onPressed: () {
                        if (controllerEmail.text == '' ||
                            controllerPass.text == '' ||
                            controllerPassCek.text == '' ||
                            controllerUsername.text == '') {
                          Scaffold.of(cont).showSnackBar(new SnackBar(
                            content: Text("Form tidak boleh ada yang kosong"),
                          ));
                        } else if (controllerPass.text !=
                            controllerPassCek.text) {
                          Scaffold.of(cont).showSnackBar(new SnackBar(
                            content: Text("Kata Sandi Salah"),
                          ));
                        } else if (controllerPass.text.length < 6) {
                          Scaffold.of(cont).showSnackBar(new SnackBar(
                            content: Text("Panjang sandi minimal 6 karakter"),
                          ));
                        } else {
                          _daftarBaru(cont);
                        }
                      },
                      shape: OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.none),
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
