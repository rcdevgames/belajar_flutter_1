import 'dart:convert';

import 'package:belajar_flutter_1/helper/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:loading_overlay/loading_overlay.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final http = ApiHelper.instance;

  bool _loading = false;
  bool _showPassword = false;
  String _email;
  String _password;
  
  FlutterSecureStorage storage = new FlutterSecureStorage();

  _login(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    final response = await http.post("Auth/login", {
      "email": _email,
      "password": _password,
      "token": "POSTMAN"
    });

    setState(() {
      _loading = false;
    });
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await storage.write(key: "token", value: data['data']['access_token']);
      final token = await storage.read(key: "token");
      print(token);
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      print(response.body);
      // showAlert(context: context, title: jsonDecode(response.body)['message']);
    }

  }

  _checkLogin(BuildContext context) async {
    final token = await storage.read(key: "token");
    if (token != null) {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  @override
  void initState() {
    _checkLogin(context);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("Halaman Login"),
      ),
      body: LoadingOverlay(
        isLoading: _loading,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Tidak boleh kosong!";
                    }
                    if (!val.contains("@")) {
                      return "Format Email Salah!";
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      _email = val;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email"
                  ),
                ),
                TextFormField(
                  validator: (val) {
                    if (val.isEmpty) {
                      return "Tidak boleh kosong!";
                    }
                  },
                  onSaved: (val) {
                    setState(() {
                      _password = val;
                    });
                  },
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.remove_red_eye, color: _showPassword ? Colors.green : Colors.grey),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      }
                    )
                  ),
                ),
                RaisedButton(
                  color: Colors.green,
                  colorBrightness: Brightness.dark,
                  child: Text("Login"),
                  onPressed: () {
                    if (_form.currentState.validate()) {
                      _form.currentState.save();
                      _login(context);
                      // Navigator.pushReplacementNamed(context, "/home");

                      // Navigator.of(context).pushReplacementNamed("/home");
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}