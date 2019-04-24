import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
     initialRoute: "/",
     routes: {
        "/" : (context) => LoginPage(),
        "/home": (context) => HomePage(),
     }, 
    )
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Dokumen Masyarakat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title : 'Login Page'),
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
  // Validasi
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // Edit text style di sini kalau mau
  final colorButton = 0xff01A0C7;
  final _hor = 15.0;
  final _ver = 20.0;

  @override 
  Widget build(BuildContext context){
    final emailField = TextFormField(
      controller: _emailController,
      validator: (value) {
        if (value.isEmpty) return "Masukan Email";
        if (value.length < 5 ) return "Email terlalu pendek";
      },
      obscureText: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final passField = TextFormField(
      controller: _passController,
      validator: (value) {
        if (value.isEmpty) return "Masukan Password";
        if (value.length < 5 ) return "Password terlalu pendek";
      },
      obscureText: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(_ver, _hor, _ver, _hor),
        hintText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    
    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(colorButton),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(_ver, _hor, _ver, _hor),
        // untuk validasi email dan password di sini
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/home'
          );
        },
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

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
      onPressed: () {},
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
                SizedBox(
                  height: 45.0,
                ),
                emailField,
                SizedBox(
                  height: 10.0,
                ),
                passField,
                SizedBox(
                  height: 30.0,
                ),
                loginButton,
                forgotLabel,
                daftar
              ],
            ),
          ),
        ),
      ),
    );
  }

}

// Home Page
class HomePage extends StatelessWidget {
  // autentikasi disini

  @override 
  Widget build(BuildContext context) {
    Widget mainDrawer = Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('Nama user'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Dokumen baru'),
          onTap: () {},
        ),
        ListTile(
          title: Text('Setting'),
          onTap: () {},
        ),
       ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Beranda"),
      ),
      drawer: mainDrawer,
      body: ListView(
        padding: const EdgeInsets.all(100.0),
        children: <Widget>[
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
          Center(
            child: Text("Satuuu... !"),
          ),
        ],
      ),
    );
  }

  // Drawer a.k.a side menu

}