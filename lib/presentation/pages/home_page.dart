import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task_1/presentation/cubit/note_cubit.dart';
import 'package:flutter_test_task_1/domain/models/note.dart';
import 'package:flutter_test_task_1/presentation/cubit/theme_cubit.dart';
import 'edit_note_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigateToEditPage(BuildContext context, [Note? note]) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage(note: note)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              final isDark = themeMode == ThemeMode.dark;
              return IconButton(
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                icon: Icon(isDark ? Icons.wb_sunny : Icons.nightlight_round),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotesCubit, NotesState>(
        builder: (context, state) {
          if (state is NotesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            final notes = state.notes;

            if (notes.isEmpty) {
              return const Center(child: Text('Нет заметок'));
            }

            return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditPage(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}