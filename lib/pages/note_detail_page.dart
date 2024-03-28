import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({super.key, required this.id});
  final int id;

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note _note;
  var _isLoading = false;

  Future<void> _refreshNote() async {
    setState(() {
      _isLoading = true;
    });

    _note = await NoteDatabase.instance.getnoteById(widget.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Detail'),
        actions: [_editButton(), _deleteButton()],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(8),
              children: [
                Text(
                  _note.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(_note.time.toString()),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _note.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
    );
  }

  Widget _editButton() {
    return IconButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddEditNotePage(note: _note)));
          _refreshNote();
        },
        icon: const Icon(Icons.edit_outlined));
  }

  Widget _deleteButton() {
    return IconButton(
        onPressed: () async {
          await NoteDatabase.instance.deleteNoteById(widget.id);
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete_outlined));
  }
}
