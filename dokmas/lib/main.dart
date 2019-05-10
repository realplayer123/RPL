import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'datadiri.dart';
import 'dok.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
     initialRoute: "/",
     routes: {
        "/" : (context) => LoginPage(),
        "/daftar": (context) => SignUpPage(),
     }, 
    );
  }
}
class SignUpPage extends StatefulWidget{
  @override
  _SignUpState createState() => new _SignUpState();
}

class _SignUpState extends State<SignUpPage>{

  TextEditingController controllerPass = new TextEditingController();
  TextEditingController controllerPassCek = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();

AlertDialog submit(){
  AlertDialog alertDialog =new AlertDialog(
    content:  new Container(
      height: 260.0,
      child: new Column(
        children: <Widget>[
          new Text("Email : ${controllerEmail.text}"),
          new Text("Kata Sandi : ${controllerPass.text}"),
           
        ],
      ),
    )
  );
  return alertDialog;
}

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        //leading: new Icon(Icons, list) buat icon
        title: new Text("Daftar Akun Baru"),
        backgroundColor: Colors.indigo,
      ),
      body: Builder(
          builder : (BuildContext cont) => ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top : 32.0, bottom: 8.0),
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
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top : 32.0, bottom: 8.0),
              child: Center(
                child: Text("Masukan Password"),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 32.0, right: 32.0),
              child: TextField(
                obscureText: true,
                controller: controllerPass,
                decoration: InputDecoration(
                  hintText: "Kata Sandi",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(top : 8.0, left: 32.0, right: 32.0),
              child: TextField(
                obscureText: true,
                controller: controllerPassCek,
                decoration: InputDecoration(
                  hintText: "Ulangi Kata Sandi",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0)
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top : 32.0, left: 32.0, right: 32.0),
              child: RaisedButton(
                child: Text("Daftar", style: TextStyle(color: Colors.white),),
                color: Colors.blueAccent,
                onPressed: (){
                  if(controllerPass.text != controllerPassCek.text) {
                    
                    Scaffold.of(cont).showSnackBar(
                      new SnackBar(content: Text("Kata Sandi Salah !"),)
                    );
                  }
                },
                shape: OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.none),
                  borderRadius: BorderRadius.circular(32.0)
                ),
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}


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

  final formKey = new GlobalKey<FormState>();

  bool validateandSave(){
    final form = formKey.currentState;
    if(form.validate()) {
      form.save();
      return true;
    }
    else{
      return false;
    }
  }

  void validateandSubmit() async{
    if(validateandSave()){
      try{
        FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _pass);
        print('masuk: ${user.uid}');

      }
      catch(e){
        print('err: $e');
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
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser userDetails = await _firebaseAuth.signInWithCredential(credential);

    UserDetails details = new UserDetails(
      userDetails.providerId, 
      userDetails.displayName,
      userDetails.photoUrl,
      userDetails.email);

    Navigator.push(context, 
      MaterialPageRoute(
        builder: (context) => HomePage(details)
      )
    );
    return userDetails;
  }

  @override 
  Widget build(BuildContext context){
    final forgotLabel = FlatButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    final daftar = FlatButton(
      child: Text(
        'Belum punya akun? Daftar disini.',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: (){
        Navigator.pushNamed(
          context,
          '/daftar'
        );
      } 
    );

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
                        .catchError((e)=>print(e)),
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
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "images/logo.png", 
                    fit: BoxFit.contain,
                  ),
                ),
                new Padding(padding: new EdgeInsets.only(top: 20.0)),
                new Form(
                  key: formKey,
                  child: new Column(
                    children: buildInputs() + loginButton(),
                  ),
                ),
                SizedBox(
                  height: 45.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                googleButton,
                forgotLabel,
                daftar
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildInputs(){
    return [
      new Padding(padding: new EdgeInsets.only(top: 20.0)),
      new Center(
        child: Text("Masukan Email"),
      ),
      new Padding(padding: new EdgeInsets.only(top: 4.0)),
      new TextFormField(
        controller: _emailController,
        validator: (value) {
          if (value.isEmpty) return "Masukan Email";
          if (value.length < 5 ) return "Email terlalu pendek";
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
        onSaved: (value) => _email = value
      ),

      new Padding(padding: new EdgeInsets.only(top: 10.0)),
      new Center(
        child: Text("Masukan Kata Sandi"),
      ),
      new Padding(padding: new EdgeInsets.only(top: 4.0)),
      new TextFormField(
        controller: _passController,
        validator: (value) {
          if (value.isEmpty) return "Masukan Password";
          if (value.length < 5 ) return "Password terlalu pendek";
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
  List<Widget> loginButton(){
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
            validateandSubmit();
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
}



// Home Page
class HomePage extends StatelessWidget {
  static const routeName = '/home';

  // autentikasi disini
  UserDetails detailsUser;
  HomePage(this.detailsUser);

  static List items;
  final String currentProfilePic = "https://www.shareicon.net/data/128x128/2017/02/07/878237_user_512x512.png";
 
  void initState(){

  }

  @override 
  Widget build(BuildContext context) {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _gSignIn = new GoogleSignIn();
    void _googleSignOut() async {
      await _firebaseAuth.signOut();
      await _gSignIn.signOut();
    }

    Widget mainDrawer = Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        new UserAccountsDrawerHeader(
              accountEmail: new Text(detailsUser.userEmail),
              accountName: new Text(detailsUser.userName),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(detailsUser.photoUrl),
                ),
              ),
              decoration: new BoxDecoration(
                color: Colors.blue,
              ),
            ),
        ListTile(
          title: Text('Data Diri'),
          
          onTap: () {
            Navigator.push(context, 
            MaterialPageRoute( builder: (context) => DiriPage(detailsUser))
            );
          },
        ),
        Divider(),
        ListTile(
          title: Text('Keluar'),
          onTap: () {
            _googleSignOut();
            Navigator.of(context).push(
              new MaterialPageRoute(builder: (BuildContext context) => LoginPage())
            );
          },
        ),
       ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
      ),
      drawer: mainDrawer,
      body: new DokPage(detailsUser),
    ); 
  }
}

class UserDetails {
  final String providerDetail;
  final String userName;
  final String photoUrl;
  final String userEmail;
  UserDetails(this.providerDetail,this.userName,this.photoUrl,this.userEmail);
}


