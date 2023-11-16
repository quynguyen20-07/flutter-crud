import 'package:crud_fltter/database.dart';
import 'package:crud_fltter/task_page.dart';
import 'package:intl/intl.dart';
import 'package:crud_fltter/model.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SubmitTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
  String? todoDT;
  bool? update;

  SubmitTask(
      {super.key,
      this.todoId,
      this.todoTitle,
      this.todoDesc,
      this.update,
      this.todoDT});

  @override
  State<SubmitTask> createState() => _handleSubmitTaskState();
}

class _handleSubmitTaskState extends State<SubmitTask> {
  DbSQLite? dbSQLite;
  late Future<List<TodoModel>> dataList;

  final _formKey = GlobalKey<FormState>();

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
    final TextEditingController titleController =
        TextEditingController(text: widget.todoTitle);
    final TextEditingController descController =
        TextEditingController(text: widget.todoDesc);

    String barTitle;

    if (widget.update == true) {
      barTitle = "Update todo";
    } else {
      barTitle = "Add todo";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          barTitle,
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 1),
        ),
        centerTitle: true,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.help_outline_rounded,
              size: 30,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: titleController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(), hintText: "Title"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter title";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          maxLines: null,
                          minLines: 5,
                          controller: descController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Description"),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter description";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Material(
                        color: Colors.green[400],
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              if (widget.update == true) {
                                dbSQLite!.updateData(TodoModel(
                                  id: widget.todoId,
                                  title: titleController.text,
                                  desc: descController.text,
                                  datetime: widget.todoDT,
                                ));
                              } else {
                                dbSQLite!.insert(TodoModel(
                                  title: titleController.text,
                                  desc: descController.text,
                                  datetime: DateFormat('yMd')
                                      .add_jm()
                                      .format(DateTime.now())
                                      .toString(),
                                ));
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const TaskPage()));

                              titleController.clear();
                              descController.clear();

                              print("Data added");
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 120,
                            // decoration: BoxDecoration(boxShadow: [
                            //   BoxShadow(
                            //       color: Colors.black12,
                            //       blurRadius: 5,
                            //       spreadRadius: 1)
                            // ]),
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.red[400],
                        borderRadius: BorderRadius.circular(15),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              titleController.clear();
                              descController.clear();
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            width: 120,
                            child: const Text(
                              "Clear",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
