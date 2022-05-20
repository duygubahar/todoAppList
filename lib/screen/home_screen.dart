import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/helpers/drawer_navigation.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/screen/todo_screen.dart';
import 'package:to_do_app/services/todo_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService? _todoService;

  List<Todo> _todoList = List<Todo>.empty();

  @override
  initState(){
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoService = TodoService();
    _todoList = List<Todo>.empty();

  var todos = await _todoService?.readTodos();

  todos.forEach((todo){
    setState(() {
      var model = Todo();
      model.id = todo ['id'];
      model.title = todo ['title'];
      model.description = todo ['description'];
      model.todoDate = todo ['todoDate'];
      model.isFinished = todo ['isFinished'];
      _todoList.add(model);
    });
  });



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      drawer: DrawerNavigation(),
      body: ListView.builder( itemCount: _todoList.length ,itemBuilder: (context,  index) {
        return Padding(
          padding:  EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            ),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_todoList[index].title ??= 'No Title'),
                ],
              ),
              subtitle: Text(_todoList[index].category ??= 'No Category') ,
              trailing: Text(_todoList[index].todoDate ??= 'No Date') ,
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async  {Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoScreen()));
        },
        child: Icon(Icons.add),
        ),
      );
  }
}