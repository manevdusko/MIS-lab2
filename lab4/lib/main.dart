import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        title: "Потсетник за испити",
        home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  DateTime showFor = DateTime.now();
  Map<String, DateTime> _ispiti = new HashMap<String, DateTime>();
  Map<String, DateTime> _showIspiti = new HashMap<String, DateTime>();
  List<String> _dates = new List<String>();
  String _newispit = "";
  String sanitizeDateTime(DateTime dateTime) =>
      "${dateTime.year}-${dateTime.month}-${dateTime.day}";
  void _dodajIspit() {
    if (_newispit.length > 0) {
      setState(() {
        DateTime ss = new DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute);
        _dates.add(sanitizeDateTime(ss));
        _ispiti[_newispit] = ss;
        print(_ispiti[_newispit]);
      });
    }
  }

  void _izbrisiIspit(int index) {
    setState(() {
      _ispiti.remove(_ispiti.keys.elementAt(index));
    });
  }

  void _promtZavrsiIspit(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text(
                'Дали испитот по предметот "${_ispiti.keys.elementAt(index)}" кој треба да го полагате на "${DateFormat('dd-MM-yyyy - kk:mm').format(_ispiti[_ispiti.keys.elementAt(index)])}" сакате да се избрише?'),
            actions: <Widget>[
              new TextButton(
                child: new Text('Не'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              new TextButton(
                child: new Text('Избриши'),
                onPressed: () {
                  _izbrisiIspit(index);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  _filterByDate(BuildContext context) async {
    DateTime sDate = _ispiti.values.last;
    final DateTime selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
      initialDate: sDate,
      selectableDayPredicate: (DateTime val) {
        String sanitized = sanitizeDateTime(val);
        return _dates.contains(sanitized);
      },
    );
    if (selected != null)
      setState(() {
        _showIspiti.clear();
        for (String ispit in _ispiti.keys) {
          if (sanitizeDateTime(_ispiti[ispit])
                  .compareTo(sanitizeDateTime(selected)) ==
              0) {
            _showIspiti[ispit] = _ispiti[ispit];
          }
        }
        showFor = selected;
      });
  }

  _selectDate(BuildContext context) async {
    final DateTime selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
      });
  }

  void _setNewispitState(String ispit) {
    if (ispit.length > 0) {
      setState(() {
        _newispit = ispit;
      });
    }
  }

  Widget _buildListaNaIspiti() {
    return new ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _showIspiti.length,
      itemBuilder: (context, index) {
        String key = _showIspiti.keys.elementAt(index);
        return new Card(
          child: new ListTile(
            title: Column(
              children: [
                new Text(
                  "$key",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                new Text(
                  "${DateFormat('dd-MM-yyyy - kk:mm').format(_ispiti[key])}",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ],
            ),
            onTap: () => _promtZavrsiIspit(index),
          ),
          margin: EdgeInsets.all(10),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Потсетник за испити'),
        actions: [
          IconButton(onPressed: _pushDodajIspit, icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            _buildListaNaIspiti(),
          ],
        ),
      ),
      floatingActionButton: _datum(),
    );
  }

  void _pushDodajIspit() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return _buildDodajIspit();
    }));
  }

  Widget _datum() {
    if (_ispiti.isEmpty) {
      return Container();
    } else {
      return FloatingActionButton(
        onPressed: () {
          _filterByDate(context);
        },
        tooltip: 'Increment',
        child: Text("датум"),
      );
    }
  }

  Widget _buildDodajIspit() {
    Widget _textElement() {
      return Column(
        children: [
          new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _dodajIspit();
            },
            onChanged: (val) {
              _setNewispitState(val);
            },
            decoration: new InputDecoration(
                hintText: 'Име на предметот',
                contentPadding: EdgeInsets.all(16)),
          ),
          ElevatedButton(
            onPressed: () {
              _selectDate(context);
            },
            child: Text("Избери датум"),
          ),
          ElevatedButton(
            onPressed: () {
              _selectTime(context);
            },
            child: Text("Избери време"),
          ),
        ],
      );
    }

    return new Scaffold(
        appBar: new AppBar(title: new Text('Додај термин за испит')),
        body: new Container(
            padding: EdgeInsets.all(16),
            child: new Column(
              children: <Widget>[
                _textElement(),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new ElevatedButton(
                      onPressed: () {
                        _dodajIspit();
                        Navigator.pop(context);
                      },
                      child: new Text("Додај"),
                    ),
                  ],
                )
              ],
            )));
  }
}
