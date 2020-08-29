import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/models/Router.dart';
import 'package:todo_app/models/Todo.dart';
import 'package:todo_app/screens/todo_item.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  List<Todo> list = [];
  Router _router = Router();
  SharedPreferences prefs;
  final _doneStyle =
      TextStyle(color: Colors.green, decoration: TextDecoration.lineThrough);

  @override
  void initState() {
    super.initState();
    _reloadList();
  }

  _toggleDoneStyle(index) {
    return list[index].status == 'F' ? _doneStyle : null;
  }

  _reloadList() async {
    prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('list');
    if (data != null) {
      setState(() {
        var objs = jsonDecode(data) as List;
        list = objs.map((e) => Todo.fromJson(e)).toList();
      });
    }
  }

  _removeItem(int index) {
    setState(() {
      list.removeAt(index);
    });
    return prefs.setString('list', jsonEncode(list));
  }

  _doneItem(int index) {
    setState(() {
      list[index].status == 'A'
          ? list[index].status = 'F'
          : list[index].status = 'A';
    });
    return prefs.setString('list', jsonEncode(list));
  }

  _showAlertDialog({String conteudo, Function function, int index}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmação'),
            content: Text(conteudo),
            actions: [
              FlatButton(
                child: Text('Não'),
                onPressed: () => Navigator.pop(context),
              ),
              FlatButton(
                child: Text('Sim'),
                onPressed: () {
                  function(index);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  handleNavigationTodoItem([index]) => index != null
      ? _router.to(page: TodoItem(list[index], index), function: _reloadList)
      : _router.to(page: TodoItem(null, -1), function: _reloadList);

  @override
  Widget build(BuildContext context) {
    _router.context = context;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.teal,
        title: Text('Todo App'),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) => Divider(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return ListTile(
              title:
                  Text('${list[index].titulo}', style: _toggleDoneStyle(index)),
              subtitle: Text('${list[index].descricao}',
                  style: _toggleDoneStyle(index)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _showAlertDialog(
                          conteudo: "Confirma a exclusão do elemento?",
                          function: _removeItem,
                          index: index)),
                  IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => _doneItem(index)),
                ],
              ),
              onTap: () => handleNavigationTodoItem(index));
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: () => handleNavigationTodoItem(),
      ),
    );
  }
}
