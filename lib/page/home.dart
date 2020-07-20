import 'dart:convert';
import 'dart:ffi';

import 'package:belajar_flutter_1/helper/db_helper.dart';
import 'package:belajar_flutter_1/models/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'form.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _key = GlobalKey<ScaffoldState>();
  final database = DatabaseHelper.instance;
  List<Todo> _data = [];
  FlutterSecureStorage storage = new FlutterSecureStorage();

  void tutup(String parameter) {
    print(parameter);
  }

  Future _onRefresh() async {
    await _queryAll();
  }

  Future _queryAll() async {
    final dataRows = await database.fetchData();
    setState((){
      _data = todoFromMap(jsonEncode(dataRows));
    });
  }

  _deleteData(int id) async {
    await database.delete(id);
    _queryAll();
  }

  _alert(BuildContext context) {
    showAlert(
      context: context,
      title: "Berhasil"
    );
  }

  _logout(BuildContext context) {
    showAlert(
      context: context,
      title: "Logout",
      body: "Apakah anda yakin ingin logout?",
      actions: [
        AlertAction(text: "Batal", onPressed: null),
        AlertAction(text: "Yakin", onPressed: () async {
          await storage.deleteAll();
          Navigator.pushReplacementNamed(context, "/");
        }),
      ]
    );
  }

  @override
  void initState() {
    _queryAll();
    super.initState();
  }

  @override
  void dispose() { 
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () => _logout(context)
        ),
        title: Text("Belajar Flutter"),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (_,i) {
            return Card(
              color: Colors.grey,
              child: ListTile(
                leading: Checkbox(
                  value: _data[i].done == 0 ? false : true, 
                  onChanged: (val) async {
                    await database.update({
                      "id": _data[i].id,
                      "done": val ? 1 : 0
                    });
                    _queryAll();
                  }
                ),
                title: Text(_data[i].title, style: TextStyle(),),
                subtitle: Text(_data[i].description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.edit), 
                      onPressed: () async {
                        var data = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FormPage(data: _data[i])
                          )
                        );
                        if (data != null) {
                          _queryAll();
                          _alert(context);
                        }
                      }
                    ),
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.delete), 
                      onPressed: () => showAlert(
                        context: context,
                        title: "Apakah anda yakin?",
                        actions: [
                          AlertAction(text: "Batal", onPressed: null),
                          AlertAction(
                            text: "Setuju", 
                            onPressed: () => _deleteData(_data[i].id)
                          ),
                        ]
                      )
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var data = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => FormPage()
            )
          );
          if (data != null) {
            _queryAll();
            _alert(context);
          }
        },
        child: Icon(Icons.add_box),
      ),
    );
  }
}