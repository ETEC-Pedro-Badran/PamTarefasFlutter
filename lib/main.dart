import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tarefas',
      home: Scaffold(
          appBar: AppBar(
            title: Text('Lista de Tarefas'),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                            labelText: "Descrição da Tarefa",
                            labelStyle: TextStyle(color: Colors.blueAccent)),
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _toDoList.add(_textController.value.text);
                          });
                        },
                        child: Text("ADD"))
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _toDoList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text("${_toDoList[index]}"),
                  ),
                ),
              )
            ],
          )),
    );
  }

  var _toDoList = <String>[
    "Estudar flutter",
    "Levar cachorro para passear",
    "Curtir a vida"
  ];

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  _saveData() async {
    String data = json.encode(_toDoList);
    File file = await _getFile();
    file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      File file = await _getFile();
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
