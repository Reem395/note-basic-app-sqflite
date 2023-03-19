import 'package:flutter/material.dart';
import 'package:note_application/presentation/Home.dart';

import '../Model/note.dart';
import '../data/local/db/db_helper.dart';
import '../util/date_time_manager.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _noteTitleController = TextEditingController();
  TextEditingController _noteBodyController = TextEditingController();
  List<Note> noteList = [];

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int colour = 4294961979;

    return Scaffold(
      appBar: AppBar(title: const Text('Add Note')),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Note Title'),
                  validator: (value) =>
                      value!.isEmpty ? 'Write Note Title' : null,
                  controller: _noteTitleController,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Note Text'),
                  validator: (value) =>
                      value!.isEmpty ? 'Write Note Body' : null,
                  controller: _noteBodyController,
                ),
                const SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        var title = _noteTitleController.value.text;
                        var noteBody = _noteBodyController.value.text;
                        Note note = Note(
                            noteTitle: title,
                            noteText: noteBody,
                            noteColor: colour,
                            isEdited: 0,
                            // noteUpdatedDate:DateTimeManager.getCurrentDate() ,
                            noteDate: DateTimeManager.getCurrentDate());
                        // note.isEdited = true;
                        print(note.isEdited);
                        saveNote(note);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HompPage()));
                    },
                    child: Text('Add Note')),
                const SizedBox(
                  height: 20,
                ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      colour = Color.fromARGB(255, 245, 190, 186).value;
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 245, 190, 186))),
                  ),
                  
                  ElevatedButton(
                    onPressed: () {
                      colour = Color.fromARGB(255, 168, 128, 205).value;
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 168, 128, 205))),
                  ),

                ElevatedButton(
                  onPressed: () {
                    colour = Color.fromARGB(255, 104, 197, 129).value;
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 104, 197, 129))),
                ),

                ElevatedButton(
                    onPressed: () {
                      colour = Color.fromARGB(255, 192, 79, 148).value;
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 192, 79, 148))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      colour = Colors.yellow.value;
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                    ),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.yellow)),
                  ),
            ],
          ),
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void saveNote(Note note) {
    DbHelper.helper.insertDb(note).then((value) =>
        value > 0 ? print('Note Saved') : print('something went wrong'));
    getNotes();
  }

  void getNotes() {
    DbHelper.helper.selectNotes().then((value) {
      setState(() {
        noteList = value;
      });
    });
  }
}
