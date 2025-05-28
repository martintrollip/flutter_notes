import 'package:flutter/material.dart';
import 'package:flutter_notes/features/notes/domain/entities/note.dart';
import 'package:intl/intl.dart';

enum _NoteCardOption { delete }

/// Displays a card for a note with options to delete it.
///
/// The card shows the note's title, content, creation date, and
/// last updated date, if applicable.
class NoteCard extends StatelessWidget {
  const NoteCard({
    required this.note,
    required this.onDelete,
    required this.onTap,
    super.key,
  });

  final Note note;
  final void Function() onTap;
  final VoidCallback onDelete;

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy/MM/dd HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: theme.textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<_NoteCardOption>(
                    icon: const Icon(Icons.more_vert),
                    tooltip: 'Note options',
                    onSelected: (_NoteCardOption result) {
                      switch (result) {
                        case _NoteCardOption.delete:
                          onDelete();
                      }
                    },
                    itemBuilder:
                        (BuildContext context) =>
                            <PopupMenuEntry<_NoteCardOption>>[
                              const PopupMenuItem<_NoteCardOption>(
                                value: _NoteCardOption.delete,
                                child: ListTile(
                                  leading: Icon(Icons.delete_outline),
                                  title: Text('Delete'),
                                ),
                              ),
                            ],
                  ),
                ],
              ),
              Text(
                note.content,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: [
                  Expanded(
                    child: Text(
                      'Created: ${_formatDateTime(note.createdAt)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (note.updatedAt.difference(note.createdAt).inSeconds > 5)
                    Expanded(
                      child: Text(
                        'Updated: ${_formatDateTime(note.updatedAt)}',
                        textAlign: TextAlign.end,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
