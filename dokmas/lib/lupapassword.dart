import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';


// Lupa Password Page
class LupaPage extends StatefulWidget {
  @override
  LupaPageState createState() => LupaPageState();
}

class LupaPageState extends State<LupaPage> {
  String _tempEmail;
  
  void _lupaPass(BuildContext conts) async {
    print("ini _tempEmail : $_tempEmail");
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _tempEmail)
          .catchError((onError) {
            Scaffold.of(conts).showSnackBar(new SnackBar(
              content: Text('Terjadi Kesalahan'),
            ));
            
        print('Dapet error : $onError');
        
      });
    } on PlatformException catch (e) {
      print(' Wadidaw error : ${e.message}');
      
    }
  }

  @override
  void initState() {
    super.initState();
    _tempEmail = '';
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Sandi"),
      ),
      body: Builder(
        builder: (BuildContext conts) => ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
                  child: Center(
                    child: Text('Masukkan Email'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 20.0, left: 20.0, right: 20.0),
                  child: TextField(
                    onChanged: (str) {
                      setState(() {
                        _tempEmail = str;
                        print(_tempEmail);
                      });
                    },
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(32.0),
                    color: Colors.blueAccent,
                    child: MaterialButton(
                      onPressed: () {
                        _lupaPass(conts);
                      },
                      child: Text('Atur Ulang Sandi',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
                  child: Text(
                    'Kami akan mengirim email untuk mengatur ulang sandi anda. Silahkan beri kami email untuk akun yang ingin anda atur ulang sandi',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}