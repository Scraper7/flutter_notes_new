import 'package:flutter_test_task_1/domain/models/note.dart';
import 'package:flutter_test_task_1/domain/repositories/note_repository.dart';
import 'package:flutter_test_task_1/data/local_storage/notes_local_data_source.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesLocalDataSource localDataSource;

  NotesRepositoryImpl(this.localDataSource);

  @override
  Future<List<Note>> getNotes() => localDataSource.loadNotes();

  @override
  Future<void> addNote(Note note) async {
    final notes = await getNotes();
    notes.add(note);
    await localDataSource.saveNotes(notes);
  }

  @override
  Future<void> updateNote(Note updatedNote) async {
    final notes = await getNotes();
    final index = notes.indexWhere((n) => n.id == updatedNote.id);
    if (index != -1) {
      notes[index] = updatedNote;
      await localDataSource.saveNotes(notes);
    }
  }

  @override
  Future<void> deleteNote(String id) async {
    final notes = await getNotes();
    notes.removeWhere((n) => n.id == id);
    await localDataSource.saveNotes(notes);
  }
}
