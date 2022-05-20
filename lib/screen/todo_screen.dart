import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/services/todo_service.dart';
import 'package:to_do_app/screen/home_screen.dart';
import 'package:to_do_app/models/category.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {

  var _todoTitleController = TextEditingController();

  var _todoDescriptionController = TextEditingController();

  var _todoDateController = TextEditingController();

  var _selectedValue;

  var _categories = List<DropdownMenuItem<String>>.from(<DropdownMenuItem<String>>[]);

  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  void initState(){
    super.initState();
    _loadCategories();
  }

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        _categories.add(DropdownMenuItem(
          child: Text(category['name']),
          value: category['name'],
        ));
      });

    });
  }

  DateTime _dateTime = DateTime.now();
  _selectedTodoDate(BuildContext context) async {
    var _pickedDate = await showDatePicker(context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if(_pickedDate != null){
      setState(() {
        _dateTime = _pickedDate;
        _todoDateController.text = DateFormat('yyyy-MM-dd').format(_pickedDate);
      });
    }
  }
  _showSuccesSnackBar(message) {
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState!.showSnackBar(new SnackBar(content: new Text('')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text('Create Todo')
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController ,
              decoration: InputDecoration(
                labelText: 'Title',
                hintText: 'Write Todo Title'
              ) ,
            ),
            TextField(
              controller: _todoDescriptionController ,
              decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Write Todo Decription'
              ) ,
            ),
            TextField(
              controller: _todoDateController ,
              decoration: InputDecoration(
                  labelText: 'Date',
                  hintText: 'Pick a date',
                prefixIcon: InkWell(
                  onTap: () {
                    _selectedTodoDate(context);
                  },//odevde doldurulacak
                  child: Icon(Icons.calendar_today),
                )
              ) ,
            ),
            DropdownButtonFormField(items: _categories,
                value: _selectedValue,
                onChanged: (value){
                  setState(() {
                    _selectedValue = value;
                  });
                }), SizedBox(
              height: 20,
            ),

            RaisedButton(

              onPressed: () async {
                var todoObject = Todo();

                //todoObject.id = Todo[0]['id'];
                todoObject.title = _todoTitleController.text;
                todoObject.description = _todoDescriptionController.text;
                todoObject.isFinished=0;
                todoObject.category = _selectedValue.toString();
                todoObject.todoDate = _todoDateController.text;

                var _todoService = TodoService();
                var result = await _todoService.saveTodo(todoObject);
                //print result

                if (result > 0) {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      HomeScreen()), ( Route<dynamic> route) => false);
                }
                print(result);
               /*if (result > 0){
                  _showSuccesSnackBar(Text('Created', style: TextStyle(color: Colors.white),));
                }
                print(result);*/
           },
              color: Colors.blue,
              child: Text('Save', style: TextStyle(color: Colors.white)),)



          ],
        ),
     )
    );
  }
}
