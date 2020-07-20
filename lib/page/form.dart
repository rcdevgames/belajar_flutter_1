import 'package:belajar_flutter_1/helper/db_helper.dart';
import 'package:belajar_flutter_1/models/todo_model.dart';
import 'package:flutter/material.dart';

class FormPage extends StatefulWidget {
  final Todo data;
  FormPage({this.data});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _key = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final database = DatabaseHelper.instance;
  String _judul;
  String _deskripsi;

  _simpan() async {
    if (widget.data == null) {
      await database.insert({
        "title": _judul,
        "description": _deskripsi
      });
    } else {
      await database.update({
        "id": widget.data.id,
        "title": _judul,
        "description": _deskripsi
      });
    }
    Navigator.pop(context, true);
  }

  @override
  void initState() {
    if (widget.data != null) {
      setState(() {
        _judul = widget.data.title;
        _deskripsi = widget.data.description;
      });
    }
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
        title: Text(
          widget.data == null ? 
          "Halaman Form Tambah":"Halaman Form Edit"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _judul,
                onSaved: (val) {
                  setState(() {
                    _judul = val;
                  });
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Tidak boleh kosong";
                  }
                },
                decoration: InputDecoration(
                  labelText: "Judul"
                ),
              ),
              TextFormField(
                initialValue: _deskripsi,
                onSaved: (val) {
                  setState(() {
                    _deskripsi = val;
                  });
                },
                validator: (val) {
                  if (val.isEmpty) {
                    return "Tidak boleh kosong";
                  }
                },
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Deskripsi"
                ),
              ),
              RaisedButton(
                color: Colors.green,
                colorBrightness: Brightness.dark,
                child: Text("Simpan"),
                onPressed: () {
                  if (_form.currentState.validate()) {
                    _form.currentState.save();
                    _simpan();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}