import 'package:note_app/models/note.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();

  NoteDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    const sql = '''
    CREATE TABLE $tableNotes (
      ${NotesFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${NotesFields.isImportant} BOOLEAN NOT NULL,
      ${NotesFields.number} INTEGER NOT NULL,
      ${NotesFields.title} TEXT NOT NULL,
      ${NotesFields.description} TEXT NOT NULL,
      ${NotesFields.time} TEXT NOT NULL
    )
    ''';
    await db.execute(sql);
  }

  Future<Note> create(Note note) async {
    final db = await instance.database;
    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(id: id);
  }

  Future<List<Note>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query(tableNotes);
    return result.map((json) => Note.fromJson(json)).toList();
  }

  Future<Note> getnoteById(int id) async {
    final db = await instance.database;
    final result = await db
        .query(tableNotes, where: '${NotesFields.id} = ?', whereArgs: [id]);
    return result.map((json) => Note.fromJson(json)).first;
  }

  Future<int> updateNote(Note note) async {
    final db = await instance.database;
    return db.update(tableNotes, note.toJson(),
        where: '${NotesFields.id} = ?', whereArgs: [note.id]);
  }

  Future<int> deleteNoteById(int id) async {
    final db = await instance.database;
    return await db
        .delete(tableNotes, where: '${NotesFields.id} = ?', whereArgs: [id]);
  }

}
