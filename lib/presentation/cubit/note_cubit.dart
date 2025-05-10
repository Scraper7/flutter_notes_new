import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task_1/domain/models/note.dart';
import 'package:flutter_test_task_1/domain/repositories/note_repository.dart';

part 'notes_state.dart';

enum SortOrder { newestFirst, oldestFirst }

class NotesCubit extends Cubit<NotesState> {
  final NotesRepository repository;
  SortOrder _sortOrder = SortOrder.newestFirst;

  NotesCubit(this.repository) : super(NotesInitial());

  Future<void> loadNotes() async {
    emit(NotesLoading());
    try {
      final notes = await repository.getNotes();
      final sortedNotes = _sortNotes(notes, _sortOrder);
      emit(NotesLoaded(sortedNotes, sortOrder: _sortOrder));
    } catch (e) {
      emit(NotesError('Ошибка при загрузке заметок'));
    }
  }

  Future<void> addNote(Note note) async {
    await repository.addNote(note);
    loadNotes();
  }

  Future<void> updateNote(Note note) async {
    await repository.updateNote(note);
    loadNotes();
  }

  Future<void> deleteNote(String id) async {
    await repository.deleteNote(id);
    loadNotes();
  }

  void changeSortOrder(SortOrder newOrder) async {
    _sortOrder = newOrder;
    if (state is NotesLoaded) {
      final notes = (state as NotesLoaded).notes;
      final sortedNotes = _sortNotes(notes, _sortOrder);
      emit(NotesLoaded(sortedNotes, sortOrder: _sortOrder));
    }
  }

  List<Note> _sortNotes(List<Note> notes, SortOrder order) {
    final sorted = [...notes];
    sorted.sort((a, b) => order == SortOrder.newestFirst
        ? b.dateCreated.compareTo(a.dateCreated)
        : a.dateCreated.compareTo(b.dateCreated));
    return sorted;
  }
}
