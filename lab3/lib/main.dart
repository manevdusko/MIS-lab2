import 'dart:collection';
import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        title: "Душко Манев лаб3 196063",
        home: new TodoList());
  }
}

class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  Map<String, String> _ispiti = new HashMap<String, String>();
  String _newispit = "";
  String _newDate = "";

  void _dodajIspit() {
    if (_newispit.length > 0) {
      setState(() {
        print("ISPIT " + _newispit + "  DATE  " + _newDate);
        _ispiti[_newispit] = _newDate;
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
                'Дали испитот по предметот "${_ispiti.keys.elementAt(index)}" кој треба да го полагате на "${_ispiti[_ispiti.keys.elementAt(index)]}" сакате да се избрише?'),
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

  void _setNewispitState(String ispit) {
    if (ispit.length > 0) {
      setState(() {
        _newispit = ispit;
      });
    }
  }

  void _setNewispitDateState(String date) {
    if (date.length > 0) {
      setState(() {
        _newDate = date;
      });
    }
  }

  Widget _buildListaNaIspiti() {
    return new ListView.builder(
      itemCount: _ispiti.length,
      itemBuilder: (context, index) {
        String key = _ispiti.keys.elementAt(index);
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
                  "${_ispiti[key]}",
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
        title: new Text('Душко Манев лаб3 196063'),
        actions: [
          IconButton(onPressed: _pushDodajIspit, icon: Icon(Icons.add))
        ],
      ),
      body: _buildListaNaIspiti(),
    );
  }

  void _pushDodajIspit() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return _buildDodajIspit();
    }));
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
          new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _dodajIspit();
            },
            onChanged: (val) {
              _setNewispitDateState(val);
            },
            decoration: new InputDecoration(
                hintText: 'Термин за полагање',
                contentPadding: EdgeInsets.all(16)),
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
