import 'package:flutter/material.dart';
import 'package:todo_list/components/gradient_app_bar.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:todo_list/themes/app_theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final toDoController = TextEditingController();

  List toDoList = [];

  Map<String, dynamic> lastRemoved;
  int lastRemovedPos;

  @override
  void initState() {
    super.initState();

    readData().then((data) {
      setState(() {
        toDoList = json.decode(data);
      });
    });
  }

  void addToDo() {
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = toDoController.text;
      toDoController.text = "";
      newToDo["ok"] = false;
      toDoList.add(newToDo);

      saveData();
    });
  }

  Future<Null> refresh() async{
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      toDoList.sort((a, b){
        if(a["ok"] && !b["ok"]) return 1;
        else if(!a["ok"] && b["ok"]) return -1;
        else return 0;
      });

      saveData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: GradientAppBar('Todo List'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 10.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 15, top: 5),
                    child: TextField(
                      controller: toDoController,
                      decoration: InputDecoration(
                        labelText: "New Todo",
                        labelStyle: regularTextStyle,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(width: 1, color: Color(0xffb6b2df)),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(width: 1, color: Color(0xffb6b2df)),
                        ),
                      ),
                    ),
                  )
                ),
                RaisedButton(
                  color: primaryColor,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  onPressed: addToDo,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(onRefresh: refresh,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 10.0),
                itemCount: toDoList.length,
                itemBuilder: buildItem,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index){
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(Icons.delete, color: Colors.white,),
        ),
      ),
      direction: DismissDirection.startToEnd,
      child: CheckboxListTile(
        title: Text(toDoList[index]["title"]),
        value: toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(toDoList[index]["ok"] ?
          Icons.check : Icons.error),),
        onChanged: (c){
          setState(() {
            toDoList[index]["ok"] = c;
            saveData();
          });
        },
      ),
      onDismissed: (direction){
        setState(() {
          lastRemoved = Map.from(toDoList[index]);
          lastRemovedPos = index;
          toDoList.removeAt(index);

          saveData();

          final snack = SnackBar(
            content: Text(
              "Todo \"${lastRemoved["title"]}\" removed!",
              style: regularTextStyle,
            ),
            backgroundColor: primaryColor,
            action: SnackBarAction(label: "undo",
              onPressed: () {
                setState(() {
                  toDoList.insert(lastRemovedPos, lastRemoved);
                  saveData();
                });
              },
              textColor: Color(0xffb6b2df),
            ),
            duration: Duration(seconds: 2),
          );

          Scaffold.of(context).removeCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snack);

        });
      },
    );
  }

  Future<File> getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> saveData() async {
    String data = json.encode(toDoList);

    final file = await getFile();
    return file.writeAsString(data);
  }

  Future<String> readData() async {
    try {
      final file = await getFile();

      return file.readAsString();
    } catch (e) {
      return null;
    }
  }

}