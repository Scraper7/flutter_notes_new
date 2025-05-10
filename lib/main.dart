import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test_task_1/presentation/cubit/note_cubit.dart';
import 'package:flutter_test_task_1/domain/repositories/notes_repository_impl.dart';
import 'package:flutter_test_task_1/data/local_storage/notes_local_data_source.dart';
import 'package:flutter_test_task_1/presentation/cubit/theme_cubit.dart';
import 'package:flutter_test_task_1/presentation/pages/notes_page.dart';

void main() {
  final localDataSource = NotesLocalDataSource();
  final notesRepository = NotesRepositoryImpl(localDataSource);

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          final cubit = NotesCubit(notesRepository);
          cubit.loadNotes(); 
          return cubit;
        }),
        BlocProvider(create: (_) => ThemeCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          title: 'Заметки',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const NotesPage(),
        );
      },
    );
  }
}