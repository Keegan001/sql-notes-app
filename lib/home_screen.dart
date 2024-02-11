import 'package:flutter/material.dart';
import 'package:flutter_tutorial_1/db_handler.dart';
import 'package:flutter_tutorial_1/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DBHelper? dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Notes SQL App',
        ),
      ),
      body: Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(
            NotesModel(
                title: 'first note',
                age: 19,
                description: 'first sql app',
                email: 'xyz@gmail.com'),
          )
              .then(
            (value) {
              print('data added');
            },
          ).onError(
            (error, stackTrace) {
              print(error.toString());
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
