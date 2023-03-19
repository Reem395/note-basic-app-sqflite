import 'package:note_application/data/local/db/constants.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../Model/note.dart';

class DbHelper {
  //private named constructor
  DbHelper._instance();
  static final DbHelper helper = DbHelper._instance();

  //  another way for singleton 👇🏼
  // static DbHelper? _helper;

  // factory DbHelper() {
  //   _helper ??= DbHelper._instance();
  //   return _helper!;
  // }

  Future<String> getDbPath() async {
    String dbPath = await getDatabasesPath();
    // String noteDb = dbPath+"/"+'$DB_NAME';
    String noteDb = join(dbPath, DB_NAME);
    return noteDb;
  }

  //get get instance from db
  // Future<Database> getDbInstance() async {
  //   int oldV=DB_VERSION-1;
  //   String path = await getDbPath();
  //   return openDatabase(path,
  //       version: DB_VERSION, onCreate: (db, version) => _onCreate(db), onUpgrade: (db,oldV,version)=>_onUpgrade(db));
  // }

// Future<void> getDbInstance() async {
//     int oldV=DB_VERSION-1;
//     String path = await getDbPath();
//     return deleteDatabase(path);
//   }
  //get get instance from db
  Future<Database> getDbInstance() async {
    int oldV = DB_VERSION - 1;
    String path = await getDbPath();
    // print(DB_VERSION);
    return openDatabase(path,
        version: DB_VERSION, onCreate: (db, version) => _onCreate(db));
  }

  void _onCreate(Database db) {
    // print('create');
    String sql =
        'create table $TABLE_NAME ($COL_NOTE_ID integer primary key autoincrement, $COL_NOTE_TEXT text, $COL_NOTE_DATE text,$COL_NOTE_TITLE text,$COL_NOTE_COLOR integer,$COL_NOTE_EDITED integer,$COL_NOTE_DATE_UPDATED text)';
    print(sql);
    db.execute(sql);
  }

    Future<int> insertDb(Note note) async {
    Database db = await getDbInstance();
    return db.insert(TABLE_NAME, note.toMap());
  }
  
    Future<List<Note>> selectNotes() async {
    Database db = await getDbInstance();
    List<Map<String, dynamic>> query =
        await db.query(TABLE_NAME, orderBy: '$COL_NOTE_DATE desc');
    return query.map((e) => Note.fromMap(e)).toList();
  }
  
    Future<int> deleteFromDb(int noteId) async {
    Database db = await getDbInstance();
    return db.delete(TABLE_NAME,where: '$COL_NOTE_ID=?',whereArgs: [noteId]);

  }

  Future<int> updateDb(Note note) async{
    Database db = await getDbInstance();
    return db.update(TABLE_NAME, note.toMap(),where:'$COL_NOTE_ID=?',whereArgs: [note.noteId]);

  }

  //     void _onUpgrade(Database db) {
  //   String sql =
  //       'ALTER table $TABLE_NAME ADD $COL_NOTE_EDITED text' ;
  //   print(sql);
  //   db.execute(sql);
  // }
}
