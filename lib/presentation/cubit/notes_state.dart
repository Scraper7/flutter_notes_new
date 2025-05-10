part of 'note_cubit.dart';

abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesLoading extends NotesState {}

class NotesLoaded extends NotesState {
  final List<Note> notes;
  final SortOrder sortOrder;

  NotesLoaded(this.notes, {this.sortOrder = SortOrder.newestFirst});
}

class NotesError extends NotesState {
  final String message;

  NotesError(this.message);
}
