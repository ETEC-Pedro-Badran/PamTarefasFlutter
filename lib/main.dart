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
  void initState() {
    super.initState();
  }

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
                        onPressed: () async {
                          // avisa o builder para atualizar a tela
                          setState(() {
                            // adicioanndo na lista de tarefas
                            _toDoList.add(_textController.value.text);
                          });
                          // salvando no arquivo
                          await _saveData();
                        },
                        child: Text("ADD"))
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                    future: _readData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<dynamic> data = snapshot.data as List<dynamic>;
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) => ListTile(
                            title: Text("${data[index]}"),
                          ),
                        );
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                        ));
                      }
                    }),
              )
            ],
          )),
    );
  }

  var _toDoList = <String>[];

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<void> _saveData() async {
    String data =
        json.encode(_toDoList); //formata um arquivo texto no formato json
    File file = await _getFile();
    file.writeAsString(data);
  }

  Future<dynamic> _readData() async {
    try {
      File file = await _getFile();
      String text = await file.readAsString();
      var data = json.decode(text);
      _toDoList = data.map<String>((e) => "$e").toList();
      return data;
    } catch (e) {
      print("$e");
    }
  }
}
