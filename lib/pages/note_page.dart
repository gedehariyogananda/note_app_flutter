import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';
import 'package:note_app/pages/note_detail_page.dart';
import 'package:note_app/widgets/note_card.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> _notes;
  var _isLoading = false;

  Future<void> _refreshNotes() async {
    setState(() => _isLoading = true);
    _notes = await NoteDatabase.instance.readAllNotes();
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          // final note = Note(
          //     isImportant: true,
          //     number: 1,
          //     title: 'Note 1',
          //     description: 'Description 1',
          //     time: DateTime.now());
          // await NoteDatabase.instance.create(note);
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddEditNotePage()));
          _refreshNotes();
        },
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _notes.isEmpty
              ? const Text('notes null')
              : MasonryGridView.count(
                  crossAxisCount: 2,
                  itemCount: _notes.length,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemBuilder: (context, index) {
                    final note = _notes[index];
                    return GestureDetector(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoteDetailPage(
                                        id: note.id!,
                                      )));
                          _refreshNotes();
                        },
                        child: NoteCardWidget(note: note, index: index));
                  }),
    );
  }
}
