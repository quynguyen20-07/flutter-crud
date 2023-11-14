import 'package:crud_fltter/database.dart';
import 'package:crud_fltter/model.dart';
import 'package:crud_fltter/up_sert.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPage();
}

class _TaskPage extends State<TaskPage> {
  DbSQLite? dbSQLite;
  late Future<List<TodoModel>> dataList;

  @override
  void initState() {
    super.initState();
    dbSQLite = DbSQLite();
    loadData();
  }

  loadData() async {
    dataList = dbSQLite!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: FutureBuilder(
              future: dataList,
              builder: (context, AsyncSnapshot<List<TodoModel>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.data!.length == 0) {
                  return Center(
                    child: Text(
                      "No tasks found",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.black),
                    ),
                  );
                } else {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      int todoId = snapshot.data![index].id!.toInt();
                      String todoTitle =
                          snapshot.data![index].title!.toString();
                      String todoDesc = snapshot.data![index].desc!.toString();
                      String todoDT =
                          snapshot.data![index].datetime!.toString();

                      return Dismissible(
                        key: ValueKey<int>(todoId),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.redAccent,
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        onDismissed: (DismissDirection direction) {
                          developer.log('$todoId', name: 'my.app.category');
                          setState(() {
                            dbSQLite!.deleteData(todoId);
                            dataList = dbSQLite!.getDataList();
                            snapshot.data!.remove(snapshot.data![index]);
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.yellow.shade300,
                                blurRadius: 4,
                                spreadRadius: 1)
                          ]),
                          child: Column(children: [
                            ListTile(
                              contentPadding: EdgeInsets.all(10),
                              title: Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Text(
                                  todoTitle,
                                  style: TextStyle(fontSize: 19),
                                ),
                              ),
                              subtitle: Text(
                                todoDesc,
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                            Divider(
                              color: Colors.black,
                              thickness: 0.8,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      todoDT,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 14),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SubmitTask(
                                                      todoId: todoId,
                                                      todoTitle: todoTitle,
                                                      todoDesc: todoDesc,
                                                      todoDT: todoDT,
                                                      update: true,
                                                    )));
                                      },
                                      child: Icon(
                                        Icons.edit_note,
                                        size: 28,
                                        color: Colors.green,
                                      ),
                                    )
                                  ]),
                            ),
                          ]),
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SubmitTask()));
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
    );
  }
}
