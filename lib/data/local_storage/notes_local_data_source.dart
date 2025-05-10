import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_test_task_1/domain/models/note.dart';

class NotesLocalDataSource {
  static const _key = 'notes_list';

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key) ?? [];
    return jsonList.map((jsonNote) => Note.fromJson(jsonNote)).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notes.map((note) => note.toJson()).toList();
    await prefs.setStringList(_key, jsonList);
  }
}