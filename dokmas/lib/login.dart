import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'lupapassword.dart';
import 'homepage.dart';
import 'main.dart';

// Login Page
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  // simpan judul page
  final String title;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _email;
  String _pass;
  String _usernames;
  bool bisaMasuk;

  final String currentProfilePic =
      "https://www.shareicon.net/data/128x128/2017/02/07/878237_user_512x512.png";
  final formKey = new GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _usernames = 'Unknown';
  }

  bool validateandSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateandSubmit(BuildContext conts) async {
    if (validateandSave()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _pass);
        print('masuk: ${user.uid}');
        // cek username akun
        DocumentReference dokref =
            Firestore.instance.collection('pengguna').document(_email);
        Firestore.instance.runTransaction((Transaction tx) async {
          await tx.get(dokref).then((DocumentSnapshot snaps) {
            _usernames = snaps.data['username'];
          });
          print('Ini isi username yang ditangkap : $_usernames');
          print('bisa masuk ? $bisaMasuk');
        });
        UserDetails userLogin = new UserDetails(_usernames, currentProfilePic, _email);
          // Navigasi ke Home
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(userLogin)));
      } catch (e) {
        print('err: $e');
        Scaffold.of(conts).showSnackBar(new SnackBar(
          content: Text('Gagal untuk masuk, periksa kembali Email dan Sandi'),
        ));
      }
    }
  }

  // Validasi
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // Edit text style di sini kalau mau
  final colorButton = 0xff01A0C7;
  final _hor = 15.0;
  final _ver = 20.0;

  // Sign in with google
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();

  Future<FirebaseUser> _signIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser userDetails =
        await _firebaseAuth.signInWithCredential(credential);

    UserDetails details = new UserDetails(
        userDetails.displayName, userDetails.photoUrl, userDetails.email);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage(details)));
    return userDetails;
  }

  Widget build(BuildContext context) {
    final forgotLabel = FlatButton(
      padding: EdgeInsets.only(bottom: 40.0),
      child: Text(
        'Lupa Kata Sandi?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (BuildContext context) => LupaPage()),
        );
      },
    );

    final daftar = FlatButton(
        padding: EdgeInsets.only(bottom: 10.0, top: 14.0),
        child: Text(
          'Belum punya akun? Daftar disini.',
          style: TextStyle(color: Colors.black54),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/daftar');
        });

    final googleButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(_ver, _hor, _ver, _hor),
        // untuk validasi email dan password di sini
        onPressed: () => _signIn(context)
            .then((FirebaseUser user) => print(user))
            .catchError((e) => print(e)),
        child: Text(
          "Sign In With Google",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Scaffold(
      body: Builder(
        builder: (BuildContext conts) => Center(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 150.0,
                        child: Image.asset(
                          "images/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      new Padding(padding: new EdgeInsets.only(top: 20.0)),
                      new Form(
                        key: formKey,
                        child: new Column(
                          children: buildInputs() + loginButton(conts),
                        ),
                      ),
                      daftar,
                      forgotLabel,
                      SizedBox(
                        height: 80.0,
                      ),
                      googleButton,
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }

  List<Widget> buildInputs() {
    return [
      new Padding(padding: new EdgeInsets.only(top: 20.0)),
      new Center(
        child: Text("Masukan Email"),
      ),
      new Padding(padding: new EdgeInsets.only(top: 4.0)),
      new TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email",
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          onSaved: (value) => _email = value),
      new Padding(padding: new EdgeInsets.only(top: 10.0)),
      new Center(
        child: Text("Masukan Kata Sandi"),
      ),
      new Padding(padding: new EdgeInsets.only(top: 4.0)),
      new TextFormField(
        controller: _passController,
        validator: (value) {
          if (value.isEmpty) return "Masukan Kata Sandi";
          if (value.length < 5) return "Kata Sandi terlalu pendek";
        },
        obscureText: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(_ver, _hor, _ver, _hor),
          hintText: "Kata Sandi",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onSaved: (value) => _pass = value,
      ),
    ];
  }

  List<Widget> loginButton(BuildContext conts) {
    return [
      new Padding(padding: new EdgeInsets.only(top: 20.0)),
      Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Color(colorButton),
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(_ver, _hor, _ver, _hor),
          onPressed: () {
            validateandSubmit(conts);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    ];
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Alamat Email tidak sah';
    else
      return null;
  }
}