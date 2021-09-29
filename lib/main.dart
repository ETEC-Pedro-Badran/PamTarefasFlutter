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
                            // adicionando na lista de tarefas
                            _toDoList.add(_textController.value.text);
                          });
                          // salvando no arquivo
                          await _saveData();
                        },
                        child: Text("ADD"))
                  ],
                ),
              ),
              FutureBuilder(
                  // aguarda o método futuro terminar
                  future: _readData(),
                  // método com resposta no futuro (função assíncrona)
                  builder: (context, snapshot) {
                    // desenha a tela com os dados atuais.
                    if (snapshot.hasData) {
                      // caso tenha dados
                      List<dynamic> data = snapshot.data as List<dynamic>;

                      return Column(
                        children: data
                            .map((e) => Dismissible(
                                  key: UniqueKey(),
                                  onDismissed: (direction) {
                                    _toDoList.remove(e);
                                    _saveData();
                                    return;
                                  },
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text("Arraste para excluir",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                  child: ListTile(
                                    leading:
                                        CircleAvatar(child: Icon(Icons.pause)),
                                    title: Text("$e"),
                                  ),
                                ))
                            .toList(),
                      );
                    } else {
                      //caso não triver dados, mostre um indicador circular de progresso
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.red),
                      ));
                    }
                  })
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
    file.writeAsString(data); //escreve no arquivo
  }

  Future<dynamic> _readData() async {
    try {
      File file = await _getFile(); // objeto que controla o arquivo (file)
      String text = await file.readAsString(); // li o conteúdo do arquivo
      var data = json.decode(
          text); // converti a string codificada em json para List<dynamic>
      _toDoList = data
          .map<String>((e) => "$e")
          .toList(); // converti List<dynamic> para List<String> e guardei na variável _toDoList
      return data;
    } catch (e) {
      print("$e");
      return [];
    }
  }
}
