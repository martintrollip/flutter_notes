import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:flutter_notes/features/notes/presentation/widgets/message_display.dart';

class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Notes'),
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        builder: (context, state) {
          switch (state.status) {
            case NotesListStatus.initial:
            case NotesListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case NotesListStatus.empty:
              return const MessageDisplay(
                icon: Icons.notes_rounded,
                message: 'Tap + to add your first note!',
              );
            case NotesListStatus.failure:
              return MessageDisplay(
                icon: Icons.error_outline_rounded,
                message: state.errorMessage ?? 'Unknown error',
              );
            case NotesListStatus.success:
              final notes = state.notes ?? [];
              assert(
                notes.isNotEmpty,
                'Notes should not be empty when status is success',
              );

              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(
                      note.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to Add/Edit Note Page
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }
}
