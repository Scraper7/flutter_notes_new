import 'package:flutter/material.dart';
import 'package:flutter_test_task_1/domain/models/note.dart';
import 'package:uuid/uuid.dart';

class EditNotePage extends StatefulWidget {
  final Note? note;

  const EditNotePage({Key? key, this.note}) : super(key: key);

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  final FocusNode contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');

    // Открываем клавиатуру на поле ввода
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(contentFocusNode);
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    contentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.note == null ? 'Создать заметку' : 'Редактировать заметку',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Заголовок'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              focusNode: contentFocusNode,
              decoration: const InputDecoration(labelText: 'Текст заметки'),
              maxLines: 10,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Заголовок не может быть пустым'),
                    ),
                  );
                  return;
                }

                final newNote = Note(
                  id: widget.note?.id ?? const Uuid().v4(),
                  title: titleController.text,
                  content: contentController.text,
                  createdAt: DateTime.now(),
                  dateCreated: DateTime.now(),
                );

                Navigator.pop(context, newNote);
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
