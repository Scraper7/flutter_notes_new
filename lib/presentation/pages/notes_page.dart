import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task_1/presentation/cubit/note_cubit.dart';
import 'package:flutter_test_task_1/domain/models/note.dart';
import 'package:flutter_test_task_1/presentation/cubit/theme_cubit.dart';
import 'edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String _searchQuery = '';

  void _navigateToEditPage(BuildContext context, [Note? note]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
    ).then((newNote) {
      if (newNote != null) {
        if (note == null) {
          context.read<NotesCubit>().addNote(newNote);
        } else {
          context.read<NotesCubit>().updateNote(newNote);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
          PopupMenuButton<SortOrder>(
            icon: const Icon(Icons.sort),
            onSelected: (order) {
              context.read<NotesCubit>().changeSortOrder(order);
            },
            itemBuilder:
                (context) => const [
                  PopupMenuItem(
                    value: SortOrder.newestFirst,
                    child: Text('Сначала новые'),
                  ),
                  PopupMenuItem(
                    value: SortOrder.oldestFirst,
                    child: Text('Сначала старые'),
                  ),
                ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Поиск...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<NotesCubit, NotesState>(
              builder: (context, state) {
                if (state is NotesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is NotesLoaded) {
                  final allNotes = state.notes;
                  final filteredNotes =
                      allNotes.where((note) {
                        return note.title.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ) ||
                            note.content.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            );
                      }).toList();

                  if (filteredNotes.isEmpty) {
                    return const Center(child: Text('Нет заметок'));
                  }

                  return ListView.builder(
                    itemCount: filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = filteredNotes[index];
                      return Dismissible(
                        key: Key(note.id.toString()),
                        background: Container(color: Colors.red),
                        onDismissed: (_) {
                          context.read<NotesCubit>().deleteNote(note.id);
                        },
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(
                            note.content.length > 50
                                ? '${note.content.substring(0, 50)}...'
                                : note.content,
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _navigateToEditPage(context, note),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is NotesError) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
