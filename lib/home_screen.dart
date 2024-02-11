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
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: notesList,
              builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    //reverse: true,
                    shrinkWrap: true,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: ValueKey<int>(snapshot.data![index].id!),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete_forever,
                          ),
                        ),
                        onDismissed: (DismissDirection direction) {
                          setState(
                            () {
                              dbHelper!.delete(snapshot.data![index].id!);
                              notesList = dbHelper!.getNotesList();
                              snapshot.data!.remove(snapshot.data![index]);
                            },
                          );
                        },
                        child: Card(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(snapshot.data![index].title.toString()),
                            subtitle: Text(
                                snapshot.data![index].description.toString()),
                            trailing:
                                Text(snapshot.data![index].age.toString()),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          )
        ],
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
              setState(() {});
              notesList = dbHelper!.getNotesList();
            },
          ).onError(
            (error, stackTrace) {
              print(error.toString());
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
