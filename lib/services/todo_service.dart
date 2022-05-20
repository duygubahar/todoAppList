import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/repositories/repository.dart';

class TodoService{
  Repository? _repository;

  TodoService(){
    _repository = Repository();
  }
  //create todo
  saveTodo(Todo todo) async {
    return await  _repository?.insertData('todos', todo.todoMap());
  }

  //read todos
  readTodos() async{
    return await _repository?.readData('todos');
  }
}