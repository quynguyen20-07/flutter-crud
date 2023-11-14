import 'package:crud_fltter/database.dart';
import 'package:crud_fltter/model.dart';
import 'package:crud_fltter/up_sert.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

import 'task_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('TO DO APP',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                  ],
                )),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note_alt_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 10),
                  const Text('Task management',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ],
              ),
              onTap: () {},
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 10),
                  const Text('User management',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: Colors.black)),
                ],
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'CRUD APP',
          style: TextStyle(
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
      body: TaskPage(),
    );
  }
}
