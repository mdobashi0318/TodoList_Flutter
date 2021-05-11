import 'package:flutter/material.dart';
import 'package:todolist/model/TodoModel.dart';
import 'package:todolist/other/Format.dart';

enum Mode { Add, Edit, Delete }

class TodoRegistrationScreen extends StatefulWidget {
  final TodoModel todoModel;
  final Mode mode;

  TodoRegistrationScreen({Key key, this.todoModel, this.mode})
      : super(key: key);

  @override
  _TodoRegistrationScreen createState() => _TodoRegistrationScreen();
}

class _TodoRegistrationScreen extends State<TodoRegistrationScreen> {
  String _title = "";
  String _date = "";
  String _detail = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.mode == Mode.Edit) {
      _title = widget.todoModel.title;
      _date = widget.todoModel.date;
      _detail = widget.todoModel.detail;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("作成画面"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: TextEditingController(text: _title),
                obscureText: false,
                decoration: InputDecoration(labelText: "タイトル"),
                onChanged: _changeTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'タイトルが入力されていません';
                  }
                  return null;
                },
              ),
              Container(
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _selectDate();
                      },
                      child: const Text("期日"),
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Text(_date),
                  ],
                ),
              ),
              TextFormField(
                  controller: TextEditingController(text: _detail),
                  obscureText: false,
                  decoration: InputDecoration(labelText: "詳細"),
                  onChanged: _changeDetail,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '詳細が入力されていません';
                    }
                    return null;
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          if (_title.isEmpty || _date.isEmpty || _detail.isEmpty) {
            _showAlert(context);
            _formKey.currentState.validate();
          } else {
            switch (widget.mode) {
              case Mode.Add:
                TodoModel(title: _title, date: _date, detail: _detail)
                    .insertTodo();
                break;
              case Mode.Edit:
                TodoModel(
                        title: _title,
                        date: _date,
                        detail: _detail,
                        createTime: widget.todoModel.createTime)
                    .updateTodo();
                break;
              case Mode.Delete:
                break;
            }
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  void _changeTitle(String text) {
    _title = text;
  }

  void _changeDate(String text) {
    _date = text;
  }

  void _changeDetail(String text) {
    _detail = text;
  }

  void _showAlert(BuildContext contex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: Text("入力されていない項目があります"),
          children: <Widget>[
            SimpleDialogOption(
              child: Text("閉じる"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime date = new DateTime.now();
    final DateTime picker = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime.now(),
        lastDate: new DateTime.now().add(new Duration(days: 360)),
        currentDate: date);
    if (picker != null) {
      setState(() {
        date = picker;
        _date = Format().setFormatString(date);
      });
    }
  }
}
