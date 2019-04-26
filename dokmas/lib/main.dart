import 'package:flutter/material.dart';
import 'dart:async';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';


void main() {
  runApp(
    MaterialApp(
     initialRoute: "/",
     routes: {
        "/" : (context) => LoginPage(),
        "/daftar": (context) => SignUpPage(),
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
class SignUpPage extends StatefulWidget{
  @override
  _SignUpState createState() => new _SignUpState();
}
class _SignUpState extends State<SignUpPage>{
  
  var agama=['Islam', 'Kristen', 'Katolik', 'Buddha', 'Konghucu', 'Hindu'];

  String gender = "";
  var _currentAgama = "Islam";

  TextEditingController controllerNama= new TextEditingController();
  TextEditingController controllerPass= new TextEditingController();
  TextEditingController controllerEmail= new TextEditingController();

String _date = '';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1920),
        lastDate: new DateTime(2019)
    );
    if(picked != null) setState(() => _date = picked.toString());
  }


void _pilihjk(String value){
  setState(() {
    gender=value;
  });
}

void submit(){
  AlertDialog alertDialog =new AlertDialog(
    content:  new Container(
      height: 260.0,
      child: new Column(
        children: <Widget>[
          new Text("Nama Lengkap : ${controllerNama.text}"),
          new Text("Email : ${controllerEmail.text}"),
          new Text("Tanggal Lahir : $_date"),
          new Text("Kata Sandi : ${controllerPass.text}"),
          new Text("Jenis Kelamin : $gender"),
          new Text("Agama : $_currentAgama"),
           
        ],
      ),
    )
  );
}

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        //leading: new Icon(Icons, list) buat icon
        title: new Text("Daftar"),
        backgroundColor: Colors.indigo,
      ),
      
      body: new ListView(
        children: <Widget>[
          new Container(
            padding: new EdgeInsets.all(10),
              child: new Column(
                children: <Widget>[
                  new TextField(
                    controller: controllerNama,
                    decoration: new InputDecoration(
                      hintText: "Nama Lengkap",
                      labelText: "Nama Lengkap",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(20.0)
                      )
                    ),
                  ),

                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                  
                  new TextField(
                    controller: controllerEmail,
                    decoration: new InputDecoration(
                      hintText: "Email",
                      labelText: "contoh: email@mail.com  ",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(20.0)
                      )
                    ),
                  ),
                  
                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                
                  new Row(
                    children: <Widget>[
                      new Text("Tanggal Lahir", style:  new TextStyle(fontSize: 15.0, color: Colors.black87),),
                      new Text(_date),
                      new RaisedButton(
                        onPressed: _selectDate,
                        child: new Text('Click me'),
                      )
                    ],
                  ),

                  new Padding(padding: new EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0)),
                  new TextField(
                    controller: controllerPass,
                    obscureText: true,
                    decoration: new InputDecoration(
                      hintText: "Kata Sandi",
                      labelText: "Kata Sandi",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(32.0)
                      )
                    ),
                  ),

                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                  new TextField(
                    obscureText: true,
                    decoration: new InputDecoration(
                      hintText: "Ulangi Kata Sandi",
                      labelText: "Ulangi Kata Sandi",
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(32.0)
                      )
                    ),
                  ),

                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                  new RadioListTile(
                    value: "L",
                    title: new Text("Laki-laki"),
                    groupValue: gender,
                    onChanged: (String value){
                      _pilihjk(value);
                    },
                    activeColor: Colors.blueGrey,

                  ),

                  new RadioListTile(
                    value: "P",
                    title: new Text("Perempuan"),
                    groupValue: gender,
                    onChanged: (String value){
                      _pilihjk(value);
                    },
                    activeColor: Colors.blueGrey,

                  ),

                  new Padding(padding: new EdgeInsets.only(top: 20.0)),
                  
                  new Row(
                    children: <Widget>[
                      new Text("Agama", style:  new TextStyle(fontSize: 20.0, color: Colors.black87)),
                      new DropdownButton<String>(
                        items: agama.map((String dropdownStringItem){
                          return new DropdownMenuItem<String>(
                            value: dropdownStringItem,
                            child: new Text(dropdownStringItem),
                          );
                        }).toList(),
                        onChanged: (String value){
                           setState(() {
                             this._currentAgama = value;
                           }); 
                        },
                        value: _currentAgama,
                      ),
                    ],
                  ),

                  

                  new RaisedButton(
                    child: new Text("DAFTAR"),
                    color: Colors.green,
                    onPressed: (){submit();
                      Navigator.pushNamed(
                        context,
                        '/home'
                      );
                    },
                  )
                ],
              ),
          )
        ],
      )
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
      onPressed: (){
        Navigator.pushNamed(
          context,
          '/daftar'
        );
      } 
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
  
  static List items;
  String currentProfilePic = "https://www.shareicon.net/data/128x128/2017/02/07/878237_user_512x512.png";
 
  void initState(){

  }

  @override 
  Widget build(BuildContext context) {
    Widget mainDrawer = Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        new UserAccountsDrawerHeader(
              accountEmail: new Text("Email@e-mail.com"),
              accountName: new Text("Nama"),
              currentAccountPicture: new GestureDetector(
                child: new CircleAvatar(
                  backgroundImage: new NetworkImage(currentProfilePic),
                ),
              ),
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new NetworkImage("https://img00.deviantart.net/35f0/i/2015/018/2/6/low_poly_landscape__the_river_cut_by_bv_designs-d8eib00.jpg"),
                  fit: BoxFit.fill
                )
              ),
            ),
        ListTile(
          title: Text('Dokumen baru'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/grid'
            );
          },
        ),
        ListTile(
          title: Text('Setting'),
          
          onTap: () {},
        ),
        Divider(),
        ListTile(
          title: Text('Keluar'),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/'
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
      body: GridView.count(
          // Create a grid with 3 columns. If you change the scrollDirection to
          // horizontal, this would produce 2 rows (if the rows exceed the screen).
          crossAxisCount: 3,
          // Generate 100 Widgets that display their index in the List
          children: List.generate(9, (index) {
            return Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(color: Colors.teal),
              child: Center(
                child: Text(
                  'Item $index',
                  style: Theme.of(context).textTheme.headline,
                ),
              ),
            );
          }),
      ),
    );
    
  }

  // Drawer a.k.a side menu

}