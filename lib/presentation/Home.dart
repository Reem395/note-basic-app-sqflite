import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_application/data/local/db/db_helper.dart';
import 'package:note_application/presentation/AddPage.dart';

import '../Model/note.dart';
import '../util/date_time_manager.dart';

class HompPage extends StatefulWidget {
  const HompPage({Key? key}) : super(key: key);

  @override
  State<HompPage> createState() => _HompPageState();
}

class _HompPageState extends State<HompPage> {
  @override
  List<Note> noteList = [];
  @override
  void initState() {
    getNotes();
    super.initState();
  }

  Widget build(BuildContext context) {
    // bool? Edited = false;
    // DbHelper se = new DbHelper();
    // DbHelper see = new DbHelper();
    // var helper = DbHelper.helper;
    // print(helper.hashCode);

    // var helper1 = DbHelper.helper;
    // print(helper1.hashCode);

    // DbHelper.helper.getDbPath();

    DbHelper.helper.getDbInstance();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: noteList.length,
                  itemBuilder: (context, index) {
                    return Card(
                      // color: Colors.noteList[index].noteColor ,
                      color: Color(noteList[index].noteColor!),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CupertinoButton(
                                minSize: double.minPositive,
                                padding: const EdgeInsets.all(5),
                                child: const Icon(Icons.edit,
                                    color: Colors.black, size: 20),
                                onPressed: () =>
                                    openEditDialog(noteList[index]),
                              ),
                              CupertinoButton(
                                minSize: double.minPositive,
                                padding: const EdgeInsets.all(3),
                                child: const Icon(Icons.close,
                                    color: Colors.black, size: 20),
                                onPressed: () {
                                  deleteNote(noteList[index].noteId!);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            noteList[index].noteTitle!,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 107, 10, 3),
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(noteList[index].noteText!),
                          const SizedBox(
                            height: 8,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                noteList[index].noteDate!,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                                // textAlign: TextAlign.center,
                              ),
                              Visibility(
                                child: IconButton(
                                    onPressed: () {
                                      showEditedDate(noteList[index]);
                                    },
                                    icon: const Icon(
                                      Icons.circle,
                                      size: 10,
                                      color: Colors.green,
                                    )),
                                visible: noteList[index].isEdited == 0
                                    ? false
                                    : true,
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 8,
                          // ),
                        ]),
                      ),
                      margin: const EdgeInsets.all(8),
                      elevation: 8,
                      shadowColor: Colors.grey,
                    );
                  }),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => const AddPage())),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  void deleteNote(int noteId) {
    DbHelper.helper.deleteFromDb(noteId).then((value) =>
        value > 0 ? print('Note deleted') : print('something went wrong'));
    getNotes();
  }

  void getNotes() {
    DbHelper.helper.selectNotes().then((value) {
      setState(() {
        noteList = value;
      });
    });
  }

  void updateNote(Note note) {
    DbHelper.helper.updateDb(note).then((value) =>
        value > 0 ? print('Note updated') : print('something went wrong'));
    // setState(() {
    //     note.isEdited = true;
    //     });
    getNotes();
  }

  showEditedDate(Note note) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Edited Date'),
              content: Text('${note.noteUpdatedDate}'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
              ],
            ));
  }

  openEditDialog(Note note) {
    GlobalKey<FormState> _dialogFormKey = GlobalKey();

    TextEditingController _editControllerTitle =
        TextEditingController(text: note.noteTitle);

    TextEditingController _editController =
        TextEditingController(text: note.noteText);

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Edit Note'),
              content: SizedBox(
                height: 100,
                child: Form(
                    key: _dialogFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              value!.isEmpty ? 'Write your Title' : null,
                          controller: _editControllerTitle,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          validator: (value) =>
                              value!.isEmpty ? 'Write your note' : null,
                          controller: _editController,
                        ),
                      ],
                    )),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel')),
                const SizedBox(
                  width: 8,
                ),
                TextButton(
                    onPressed: () {
                      if (_dialogFormKey.currentState!.validate()) {
                        String newText = _editController.value.text;
                        String newTitle = _editControllerTitle.value.text;
                        note.noteText = newText;
                        note.noteTitle = newTitle;
                        note.isEdited = 1;
                        note.noteUpdatedDate = DateTimeManager.getCurrentDate();
                        // note.noteDate = DateTimeManager.getCurrentDate();
                        updateNote(note);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Edit'))
              ],
            ));
  }
}
