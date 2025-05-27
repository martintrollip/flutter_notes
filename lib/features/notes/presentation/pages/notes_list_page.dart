// ignore_for_file: lines_longer_than_80_chars, use_if_null_to_convert_nulls_to_bools

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes/features/notes/domain/domain.dart';
import 'package:flutter_notes/features/notes/presentation/bloc/notes_bloc.dart';
import 'package:flutter_notes/features/notes/presentation/pages/pages.dart';
import 'package:flutter_notes/features/notes/presentation/widgets/message_display.dart';
import 'package:flutter_notes/features/notes/presentation/widgets/note_card.dart';

class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [_RefreshButton(key: Key('refresh'))],
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
                  return NoteCard(
                    note: note,
                    onTap: (note) {
                      _onNoteTap(context, note);
                    },
                    onDelete: () {
                      _showDeleteConfirmationDialog(context, note.id);
                    },
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder:
                  (_) => AddEditNotePage(
                    onSuccess: () {
                      context.read<NotesBloc>().add(
                        const NotesEvent.refreshNotes(),
                      );
                    },
                  ),
            ),
          );
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onNoteTap(BuildContext context, Note note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => AddEditNotePage(note: note)),
    );
    if (result == true && context.mounted) {
      context.read<NotesBloc>().add(const NotesEvent.refreshNotes());
    }
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context,
    String noteId,
  ) async {
    final bloc = context.read<NotesBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogueContext) {
        return AlertDialog(
          title: const Text('Delete Note?'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogueContext).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogueContext).pop(true);
              },
            ),
          ],
        );
      },
    );
    if (confirmed ?? false) {
      bloc.add(NotesEvent.deleteNote(noteId: noteId));
    }
  }
}

/// A button to refresh notes
class _RefreshButton extends StatelessWidget {
  const _RefreshButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(16),
      icon: const Icon(Icons.refresh_rounded),
      tooltip: 'Reload Notes',
      onPressed:
          () => context.read<NotesBloc>().add(const NotesEvent.refreshNotes()),
    );
  }
}
